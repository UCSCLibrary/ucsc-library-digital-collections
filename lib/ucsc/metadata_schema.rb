module Ucsc
  class MetadataSchema < ScoobySnacks::MetadataSchema

    def self.custom_display_groups
      [:admin_only, :add_parent_value]
    end

     define_display_group_methods(custom_display_groups)
    #TODO : move add_parent_value_display_field_names into ScoobySnacks/lib/metadata.rb
    #Adding it under display groups just for convenience since add_parent_value_field_names methods have to be written on ScoobySnacks end
    def display_field_names
      super + admin_only_display_field_names + add_parent_value_display_field_names
    end

    def display_fields
      super + admin_only_display_fields + add_parent_value_display_fields
    end
    
  end
end
