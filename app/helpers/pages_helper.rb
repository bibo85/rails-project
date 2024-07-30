# frozen_string_literal: true

# Модуль-помощьник для контроллера Page. Помогает преобразовывать и отображать сложные структуры.
module PagesHelper
  # Рекурсивно отображает иерархию всех страниц от указанной в параметре pages. Если у страницы есть дочерние страницы,
  # то внутри вызывается метод render_subpages, который рекурсивно обходит все дочерние страницы.
  #
  # @param pages [Page::ActiveRecord_Relation] экземпляр модели Page, содержащий объекты страниц текущего уровня
  # @param url [String] текущий url от которого будут построены ссылки на страницы, по умолчанию пустой
  # @example
  #   pages =
  #     <ActiveRecord::Relation [
  #       #<Page id: 84, name: "first_page_first_lvl", title: "Страница 1 уровня 1", body: "Страница 1 уровня 1 текст",
  #         created_at: "2024-07-25 13:08:26.087801000 +0000", updated_at: "2024-07-25 13:08:26.087801000 +0000",
  #         ancestry: "/">,
  #       #<Page id: 85, name: "second_page_first_lvl", title: "Страница 2 уровня 1", body: "Страница 2 уровня 1 текст",
  #         created_at: "2024-07-25 13:09:01.121905000 +0000", updated_at: "2024-07-25 13:17:37.707459000 +0000",
  #         ancestry: "/">
  #     ]>
  # @see Page
  def render_page_hierarchy(pages, url = '')
    content_tag(:ul, class: 'nav flex-column') do
      pages.each do |page|
        current_url = "#{url}#{page.name}"
        concat(content_tag(:li, link_to(page.title, current_url), class: 'nav-item'))
        render_subpages(page.descendants.arrange, "#{current_url}/") if page.descendants.arrange.present?
      end
    end
  end

  # Метод принимает на вход строку текста и форматирует ее:
  # - заменяет специальные символы на html-теги:
  #   *[строка]* заменяется на <strong>строка</strong>
  #   \\[строка]\\ заменяется на <i>строка</i>
  #   ((name1/name2/name3 [строка])) заменяется на ссылку вида <a href="[site]name1/name2/name3">[строка]</a>
  # - превращает строку в безопасную, экранируя небезопасные аргументы, что позволяет использовать html-теги из "белого"
  #   списка
  #
  # @param text [String] строка текста для форматирования
  # @return [String] отформатированная строка, подготовленная для отображения на странице
  def get_formatted_text_page(text)
    text = text.gsub(/\*\[(.*?)\]\*/) { "<strong>#{::Regexp.last_match(1)}</strong>" } # жирный текст
    text = text.gsub(/\\\\\[(.*?)\]\\\\/) { "<em>#{::Regexp.last_match(1)}</em>" } # курсив
    text = # ссылка
      text.gsub(/\(\((.*?) (.*?)\)\)/) do
        "<a href='/#{::Regexp.last_match(1)}'>#{::Regexp.last_match(2)}</a>"
      end
    text.html_safe
  end

  private

  # Метод отображает иерархию всех дочерних страниц
  #
  # @param pages [Page::ActiveRecord_Relation] экземпляр модели Page, содержащий объекты страниц текущего уровня
  # @param url [String] текущий url от которого будут построены ссылки на страницы, по умолчанию пустой
  def render_subpages(pages, url = '')
    concat(
      content_tag(:ul, class: 'nav flex-column nested_nav') do
        pages.each do |page, children|
          current_url = "#{url}#{page.name}"
          concat(content_tag(:li, link_to(page.title, current_url), class: 'nav-item'))
          render_subpages(children, "#{current_url}/") if children.present?
        end
      end
    )
  end
end
