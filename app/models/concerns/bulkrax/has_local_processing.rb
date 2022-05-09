# frozen_string_literal: true

module Bulkrax::HasLocalProcessing
  include ControlledIndexerBehavior

  SOURCES_OF_AUTHORITIES = {
    # local db, faster
    ::Qa::Authorities::Local => 'local',
    # remote, slower
    ::Qa::Authorities::Loc => 'loc',
    ::Qa::Authorities::Getty => 'getty'
  }.freeze
  DATE_INGEST_FIELDS = %w[
    dateCreatedIngest
    dateOfSituationIngest
  ].freeze

  # This method is called during build_metadata
  # add any special processing here, for example to reset a metadata property
  # to add a custom property from outside of the import data
  def add_local
    remap_resource_type
    process_date_ingest_fields
    add_controlled_fields
  end

  # OVERRIDE: Don't fill in blank rights statements. Allow them to be blank.
  # Only override rights_statement if the user chose to override them in
  # the Importer form.
  def add_rights_statement
    parsed_metadata['rightsStatement'] = [parser.parser_fields['rights_statement']] if override_rights_statement
  end

  private

  # TODO: Rename "resourceType_attributes" to "resource_type_attributes" after
  # ScoobySnacks is removed -- resourceType will no longer exist
  def remap_resource_type
    return unless is_a?(Bulkrax::CsvFileSetEntry)

    parsed_metadata.delete('resourceType_attributes')
    parsed_metadata['resource_type'] = raw_metadata['resourcetype']&.split(/\s*[|]\s*/)
  end

  def process_date_ingest_fields
    DATE_INGEST_FIELDS.each do |ingest_field|
      next unless parsed_metadata[ingest_field].present?

      sortable_field = ingest_field.sub('Ingest', '')
      parsed_metadata[ingest_field].each do |value|
        value = value.dup.strip
        next if value.blank?

        sortable_date = if value.match?(/^\d{4}$/)
                          "#{value}-12-31" # sort YYYY dates at the end of their year
                        elsif value.match?(/^\d{4}-\d{2}-\d{2}$/)
                          value
                        else
                          raise StandardError, %("#{value}" is not a valid date value for #{ingest_field})
                        end

        parsed_metadata[sortable_field] ||= []
        parsed_metadata[sortable_field] << Date.parse(sortable_date).to_s
      end
    end
  end

  # Controlled fields expect an ActiveTriples instance as a value. Bulkrax only imports strings.
  # Use the imported string values to lookup or create valid ActiveTriples URIs and add them
  # to the Entry's parsed_metadata in the format that the actor stack expects.
  def add_controlled_fields
    metadata_schema = ::ScoobySnacks::METADATA_SCHEMA

    metadata_schema.controlled_field_names.each do |field_name|
      field = metadata_schema.get_field(field_name)
      raw_metadata_for_field = raw_metadata.select { |k, _v| k.match?(/#{field_name.downcase}(_\d+)?/) }
      next if raw_metadata_for_field.blank?

      all_values = raw_metadata_for_field.values.compact&.map { |value| value.split(/\s*[|]\s*/) }&.flatten
      parsed_metadata[field_name] = []
      next if all_values.blank?

      parsed_metadata.delete(field_name) # replacing field_name with field_name_attributes
      all_values.each_with_index do |value, i|
        auth_id = value if value.match?(::URI::DEFAULT_PARSER.make_regexp) # assume raw, user-provided URI is a valid authority
        auth_id ||= search_authorities_for_id(field, value)
        auth_id ||= create_local_authority_id(field, value)
        next unless auth_id.present?

        parsed_metadata["#{field_name}_attributes"] ||= {}
        parsed_metadata["#{field_name}_attributes"][i] = { 'id' => auth_id }
      end
    end
  end

  # @return [String, nil] URI for authority, or nil if one could not be found
  def search_authorities_for_id(field, value)
    found_id = nil

    SOURCES_OF_AUTHORITIES.each do |auth_source, auth_name|
      subauth_name = get_subauthority_for(field: field, authority_name: auth_name)
      next unless subauth_name.present?

      subauthority = auth_source.subauthority_for(subauth_name)
      found_id = subauthority.search(value)&.first&.dig('id')
    end

    found_id
  end

  # @return [String, nil] URI for local authority, or nil if one could not be created
  def create_local_authority_id(field, value)
    local_subauth_name = get_subauthority_for(field: field, authority_name: 'local')
    mint_local_auth_url(local_subauth_name, value) if local_subauth_name.present?
  end
end
