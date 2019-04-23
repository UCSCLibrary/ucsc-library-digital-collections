module UcscCatalogHelper
  def label_for_search_field(key)
    field = ScoobySnacks::METADATA_SCHEMA.all_field_names.find{|field_name| key.include?(field_name)}
    return field.label if field
    super
  end
end
