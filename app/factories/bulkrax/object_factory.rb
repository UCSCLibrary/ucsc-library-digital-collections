# frozen_string_literal: true

require_dependency Bulkrax::Engine.root.join('app', 'factories', 'bulkrax', 'object_factory').to_s

# OVERRIDE FILE from Bulkrax v3.0.0
Bulkrax::ObjectFactory.class_eval do
  private

  # OVERRIDE: Null out each controlled field before saving, meaning only
  # incoming values will persist on the record. This results in blank
  # controlled values in ingested CSVs being "deleted".
  def update_collection(attrs)
    # OVERRIDE: add call to custom #null_controlled_fields! method
    null_controlled_fields!(attrs)

    object.attributes = attrs
    object.save!
  end

  # OVERRIDE: Add custom method to make Bulkrax and ScoobySnacks more compatible
  def null_controlled_fields!(attrs)
    ::ScoobySnacks::METADATA_SCHEMA.controlled_field_names.each do |field_name|
      # do not null fields that are not being changed
      next unless attrs.keys.include?("#{field_name}_attributes")

      object.public_send("#{field_name}=", [])
    end
  end

  def permitted_attributes
    additional_attrs = %i[
      id
      edit_users
      edit_groups
      read_groups
      visibility
      work_members_attributes
      admin_set_id
      member_of_collections_attributes
    ]
    # OVERRIDE: permit controlled field attribute hashes
    ::ScoobySnacks::METADATA_SCHEMA.controlled_field_names.each do |field_name|
      additional_attrs << "#{field_name}_attributes".to_sym
    end

    klass.properties.keys.map(&:to_sym) + additional_attrs
  end
end
