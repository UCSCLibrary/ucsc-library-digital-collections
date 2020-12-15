# Customized from Hyrax 2.9
# Removes a truncate() in the render_element function
class Hyrax::BootstrapBreadcrumbsBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder
  include ActionView::Helpers::OutputSafetyHelper

  def render
    return "" if @elements.blank?

    @context.content_tag(:nav, breadcrumbs_options) do
      @context.content_tag(:ol) do
        safe_join(@elements.uniq.collect { |e| render_element(e) })
      end
    end
  end

  def render_element(element)
    html_class = 'active' if @context.current_page?(compute_path(element)) || element.options["aria-current"] == "page"

    @context.content_tag(:li, class: html_class) do
      @context.link_to_unless(html_class == 'active', compute_name(element), compute_path(element), element.options)
    end
  end

  def breadcrumbs_options
    { class: 'breadcrumb', role: "region", "aria-label" => "Breadcrumb" }
  end
end
