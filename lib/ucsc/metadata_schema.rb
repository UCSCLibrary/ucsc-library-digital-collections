module Ucsc
  class MetadataSchema < ScoobySnacks::MetadataSchema

    def self.custom_display_groups
      [:admin_only]
    end

     define_display_group_methods(custom_display_groups)

    def display_field_names
      super + admin_only_display_field_names
    end

    def display_fields
      super + admin_only_display_fields
    end
    
  end
end
