# frozen_string_literal: true

module PagesHelper
  def render_page_hierarchy(pages, url = "")
    content_tag(:ul, class: "nav flex-column") do
      pages.each do |page|
        current_url = "#{url}#{page.name}"
        concat(content_tag(:li, link_to(page.name, current_url), class: "nav-item"))
        render_subpages(page.descendants.arrange, "#{current_url}/")
      end
    end
  end

  def render_subpages(pages, url = "")
    concat(
      content_tag(:ul, class: "nav flex-column nested_nav") do
        pages.each do |page, children|
          current_url = "#{url}#{page.name}"
          concat(content_tag(:li, link_to(page.name, current_url), class: "nav-item"))
          render_subpages(children, "#{current_url}/") if children.present?
        end
      end
    )
  end
end
