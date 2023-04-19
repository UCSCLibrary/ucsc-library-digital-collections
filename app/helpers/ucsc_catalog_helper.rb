module UcscCatalogHelper
  def label_for_search_field(key)
    if key.nil?
      return super
    end
    field_name = ScoobySnacks::METADATA_SCHEMA.all_field_names.find{|name| key.include?(name)}
    label = ScoobySnacks::METADATA_SCHEMA.get_field(field_name).label if field_name
    return label || super
  end
  
  def render_facet_partials fields = facet_field_names, options = {}
    safe_join(facets_from_request(fields).map do |display_facet|
      render_facet_limit(display_facet, options)
    end.compact, "\n")
  end

  ##
  # Renders a single section for facet limit with a specified
  # solr field used for faceting. Can be over-ridden for custom
  # display on a per-facet basis. 
  #
  # @param [Blacklight::Solr::Response::Facets::FacetField] display_facet 
  # @param [Hash] options parameters to use for rendering the facet limit partial
  # @option options [String] :partial partial to render
  # @option options [String] :layout partial layout to render
  # @option options [Hash] :locals locals to pass to the partial
  # @return [String] 
  def render_facet_limit(display_facet, options = {})
    return unless should_render_facet?(display_facet)
    options = options.dup
    options[:partial] ||= facet_partial_name(display_facet)
    options[:layout] ||= "facet_layout" unless options.key?(:layout)
    options[:locals] ||= {}
    options[:locals][:field_name] ||= display_facet.name
    options[:locals][:solr_field] ||= display_facet.name # deprecated
    options[:locals][:facet_field] ||= facet_configuration_for_field(display_facet.name)
    options[:locals][:display_facet] ||= display_facet 

    render(options)
  end
end
