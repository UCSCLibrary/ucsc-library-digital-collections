# This class extends its Hyrax equivalent to remove some truncation functions
# This extension added while using Hyrax 2.9
class Ucsc::BootstrapBreadcrumbsBuilder < Hyrax::BootstrapBreadcrumbsBuilder

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

end
