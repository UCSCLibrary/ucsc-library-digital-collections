module Ucsc
  class MetadataSchema < ScoobySnacks::MetadataSchema

    def custom_display_groups
      [:admin_only]
    end

    def display_field_names
      super + admin_only_display_field_names
    end

    def admin_only_display_fields
      @admin_only_display_field_names.map{|name| get_field(name)} unless @admin_only_display_field_names.blank?
      fields = @fields.values.select{|field| field.in_display_group? "admin" && !field.hidden?}
      @admin_only_display_field_names = fields.map{|field| field.name}
      return fields
    end

    def admin_only_display_field_names
      @admin_only_display_field_names || admin_only_display_fields.map{|field| field.name}
    end

  end
end
