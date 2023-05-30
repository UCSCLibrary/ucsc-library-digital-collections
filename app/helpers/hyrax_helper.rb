module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

  def visibility_badge(value)
    Ucsc::PermissionBadge.new(value).render
  end
  ##
  # Renders a single facet item
  def render_facet_item(facet_field, item)
    content_tag(:span, :class => "facet-label") do facet_display_value(facet_field, item) end + render_facet_count(item.hits)
  end
  ##
  # Standard display of a SELECTED facet value (e.g. without a link and with a remove button)
  # @see #render_facet_value
  # @param [Blacklight::Solr::Response::Facets::FacetField] facet_field
  # @param [String] item
  def render_selected_facet_value(facet_field, item)
    remove_href = search_action_path(search_state.remove_facet_params(facet_field, item))
    content_tag(:span, class: "facet-label") do
      content_tag(:span, facet_display_value(facet_field, item), class: "selected") +
      # remove link
      link_to(remove_href, class: "remove") do
        content_tag(:span, '', class: "glyphicon glyphicon-remove") +
        content_tag(:span, '[remove]', class: 'sr-only')
      end
    end + render_facet_count(item.hits, :classes => ["selected"])
  end

  ##
  # Standard display of a facet value in a list. Used in both _facets sidebar
  # partial and catalog/facet expanded list. Will output facet value name as
  # a link to add that to your restrictions, with count in parens.
  #
  # @param [Blacklight::Solr::Response::Facets::FacetField] facet_field
  # @param [Blacklight::Solr::Response::Facets::FacetItem] item
  # @param [Hash] options
  # @option options [Boolean] :suppress_link display the facet, but don't link to it
  # @return [String]
  def render_facet_value(facet_field, item, options ={})
    # path = path_for_facet(facet_field, item)
    content_tag(:span, :class => "facet-label") do
      link_to_unless(options[:suppress_link], facet_display_value(facet_field, item), path, :class=>"facet_select")
    end + render_facet_count(item.hits)
  end

  ##
  # Renders the list of values 
  # removes any elements where render_facet_item returns a nil value. This enables an application
  # to filter undesireable facet items so they don't appear in the UI
  def render_facet_limit_list(paginator, facet_field, wrapping_element=:div)
      # safe_join(paginator.items.map { |item| render_facet_item(facet_field, item) }.compact.map { |item| content_tag(wrapping_element,item)})
      # safe_join(paginator.items.map { |item| render_facet_item(facet_field, item) }.compact.map)
      
  end
end
