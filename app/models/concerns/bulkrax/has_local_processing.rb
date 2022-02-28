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

  # This method is called during build_metadata
  # add any special processing here, for example to reset a metadata property
  # to add a custom property from outside of the import data
  def add_local
    remap_rights_statement
    remap_resource_type
    add_controlled_fields
  end

  private

  # TODO: Remove after ScoobySnacks is removed -- rightsStatement will no longer exist
  def remap_rights_statement
    parsed_metadata['rightsStatement'] = parsed_metadata.delete('rights_statement')
    return unless override_rights_statement || parsed_metadata['rightsStatement'].blank?

    parsed_metadata['rightsStatement'] = [parser.parser_fields['rights_statement']]
  end

  # TODO: Rename "resourceType_attributes" to "resource_type_attributes" after
  # ScoobySnacks is removed -- resourceType will no longer exist
  def remap_resource_type
    return unless is_a?(Bulkrax::CsvFileSetEntry)

    parsed_metadata.delete('resourceType_attributes')
    parsed_metadata['resource_type'] = raw_metadata['resourcetype']&.split(/\s*[|]\s*/)
  end

  # Controlled fields expect an ActiveTriples instance as a value. Bulkrax only imports strings.
  # Use the imported string values to lookup or create valid ActiveTriples URIs and add them
  # to the Entry's parsed_metadata in the format that the actor stack expects.
  def add_controlled_fields
    metadata_schema = ::ScoobySnacks::METADATA_SCHEMA

    metadata_schema.controlled_field_names.each do |field_name|
      field = metadata_schema.get_field(field_name)
      parsed_metadata.delete(field_name) # remove non-standardized values
      raw_metadata_keys_for_field = raw_metadata.select { |k, _v| k.match?(/#{field_name.downcase}(_\d+)?/) }&.keys
      next if raw_metadata_keys_for_field.blank?

      raw_metadata_keys_for_field.each do |k|
        next if raw_metadata[k].blank?

        raw_metadata[k].split(/\s*[|]\s*/).uniq.each_with_index do |value, i|
          auth_id = value if value.match?(::URI::DEFAULT_PARSER.make_regexp) # assume raw, user-provided URI is a valid authority
          auth_id ||= search_authorities_for_id(field, value)
          auth_id ||= create_local_authority_id(field, value)
          next unless auth_id.present?

          parsed_metadata["#{field_name}_attributes"] ||= {}
          parsed_metadata["#{field_name}_attributes"][i] = { 'id' => auth_id }
        end
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
