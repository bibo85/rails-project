# frozen_string_literal: true

module PagesHelper
  def render_page_hierarchy(pages, url = "")
    content_tag(:ul, class: "nav flex-column") do
      pages.each do |page|
        current_url = "#{url}#{page.name}"
        concat(content_tag(:li, link_to(page.title, current_url), class: "nav-item"))
        render_subpages(page.descendants.arrange, "#{current_url}/")
      end
    end
  end

  def render_subpages(pages, url = "")
    concat(
      content_tag(:ul, class: "nav flex-column nested_nav") do
        pages.each do |page, children|
          current_url = "#{url}#{page.name}"
          concat(content_tag(:li, link_to(page.title, current_url), class: "nav-item"))
          render_subpages(children, "#{current_url}/") if children.present?
        end
      end
    )
  end

  def get_formatted_text_page(text)
    text = text.gsub(/\*\[(.*?)\]\*/) { "<strong>#{$1}</strong>" }  # жирный текст
    text = text.gsub(/\\\\\[(.*?)\]\\\\/) { "<em>#{$1}</em>" }  # курсив
    text = text.gsub(/\(\((.*?) (.*?)\)\)/) { "<a href='/#{$1}'>#{$2}</a>" }  # ссылка
    text.html_safe
  end
end
