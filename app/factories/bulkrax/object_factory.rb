# frozen_string_literal: true

require_dependency Bulkrax::Engine.root.join('app', 'factories', 'bulkrax', 'object_factory').to_s

Bulkrax::ObjectFactory.class_eval do
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
  private :permitted_attributes
end
