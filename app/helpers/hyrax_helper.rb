module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

  def visibility_badge(value)
    Ucsc::PermissionBadge.new(value).render
  end
  def render_facet_limit_list(paginator, facet_field, wrapping_element=:li)
    safe_join(paginator.items.map { |item| render_facet_item1(facet_field, item) }.compact.map { |item| content_tag(wrapping_element,item)})
  end
end


def render_facet_item1(facet_field, item)
    if facet_in_params?(facet_field, item.value )
      render_selected_facet_value(facet_field, item)          
    else
      render_facet_value1(facet_field, item)
    end
  end

  def render_facet_value1(facet_field, item, options ={})
    path = path_for_facet(facet_field, item)
    content_tag(:span, :class => "facet-label") do
      link_to_unless(options[:suppress_link], label_tag("test", :class => "checkbox inline") do check_box_tag("test") + facet_display_value(facet_field, item) end, path, :class=>"facet_select")
    end + content_tag("span", t('blacklight.search.facets.count', :number => number_with_delimiter(item.hits), :style=>"float:right"))
  end