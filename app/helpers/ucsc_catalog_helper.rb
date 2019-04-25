module UcscCatalogHelper
  def label_for_search_field(key)
    field_name = ScoobySnacks::METADATA_SCHEMA.all_field_names.find{|name| key.include?(name)}
    label = ScoobySnacks::METADATA_SCHEMA.get_field(field_name).label if field_name
    return label || super
  end
end
