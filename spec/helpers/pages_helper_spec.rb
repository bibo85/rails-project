# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesHelper, type: :helper do
  describe '#render_page_hierarchy' do
    it 'render page tree without subpages' do
      pages = %w[name_first name_second name_third].map do |name|
        FactoryBot.create(:page, name: name, title: "#{name}_title", body: "#{name}_body")
      end
      res = helper.render_page_hierarchy(pages)
      expected = '<ul class="nav flex-column"><li class="nav-item"><a href="name_first">name_first_title</a></li><li class="nav-item"><a href="name_second">name_second_title</a></li><li class="nav-item"><a href="name_third">name_third_title</a></li></ul>'
      expect(res).to eq(expected)
    end

    it 'render page tree with subpages' do
      pages_data = [
        {name: 'name_first', title: 'first_title', body: 'first_body', parent_id: ''},
        {name: 'name_second', title: 'second_title', body: 'second_body', parent_id: ''},
        {name: 'name_third', title: 'third_title', body: 'third_body', parent_id: '1'},
        {name: 'name_fourth', title: 'fourth_title', body: 'fourth_body', parent_id: '3'},
      ]
      pages = pages_data.map do |page|
        FactoryBot.create(:page,
                          name: page[:name],
                          title: page[:title],
                          body: page[:body],
                          parent_id: page[:parent_id]
        )
      end
      puts pages.inspect
      res = helper.render_page_hierarchy(pages)
      puts res.inspect
      expected = '<ul class="nav flex-column"><li class="nav-item"><a href="name_first">first_title</a></li><li class="nav-item"><a href="name_second">second_title</a></li><ul class="nav flex-column nested_nav"><li class="nav-item"><a href="name_third">third_title</a></li></ul><ul class="nav flex-column nested_nav"><li class="nav-item"><a href="name_fourth">fourth_title</a></li></ul></ul>'
      expect(res).to eq(expected)
    end
  end

  describe '#get_formatted_text_page' do
    it 'formats text (bold, italics, links)' do
      text = "*[bold]* \\\\[italic]\\\\ ((name1/name2/name3 [ссылка]))"
      res = helper.get_formatted_text_page(text)
      expect(res).to eq("<strong>bold</strong> <em>italic</em> <a href='/name1/name2/name3'>[ссылка]</a>")
    end
  end
end