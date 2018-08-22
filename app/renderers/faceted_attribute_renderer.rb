class FacetedAttributeRenderer < Hyrax::Renderers::FacetedAttributeRenderer    
  def li_value(value)
    link_to(ERB::Util.h(value), search_path(value.downcase))
  end
  
  def search_field
    ERB::Util.h(Solrizer.solr_name(options.fetch(:search_field, field), :facetable))
  end
end

