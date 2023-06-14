module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

  def visibility_badge(value)
    Ucsc::PermissionBadge.new(value).render
  end
  #OVERRIDE from blacklight to render checkbox with facet values
  def render_facet_limit_list(paginator, facet_field, wrapping_element=:li)
    safe_join(paginator.items.map { |item| render_facet_item_cb(facet_field, item) }.compact.map { |item| content_tag(wrapping_element,item)})
  end
end

# overrides the render_facet_item from blacklight facets helper
def render_facet_item_cb(facet_field, item)
    if facet_in_params?(facet_field, item.value )
      render_selected_facet_value_cb(facet_field, item)          
    else
      render_facet_value_cb(facet_field, item)
    end
end

# overrides render_facet_value from blacklight facets helper
def render_facet_value_cb(facet_field, item, options ={})
  path = path_for_facet(facet_field, item)
  content_tag(:span, :class => "facet-label") do
    link_to_unless(options[:suppress_link], label_tag("facet", :class => "checkbox inline") do check_box_tag("facet") + facet_display_value(facet_field, item) + content_tag("span", t('blacklight.search.facets.count', :number => number_with_delimiter(item.hits)), :style=>"float:right") end, path, :class=>"facet_select")
  end 
end


# overrides render_selected_facet_value from blacklight facets helper
def render_selected_facet_value_cb(facet_field, item)
  remove_href = search_action_path(search_state.remove_facet_params(facet_field, item))
  content_tag(:span, :class => "facet-label") do
      link_to(remove_href, class: "remove") do
        label_tag("facet", :class => "checkbox inline") do check_box_tag("facet",'yes', true) + facet_display_value(facet_field, item) + content_tag("span", t('blacklight.search.facets.count', :number => number_with_delimiter(item.hits)), :style=>"float:right") end 
      end
  end 
end
