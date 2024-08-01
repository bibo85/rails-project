# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesHelper, type: :helper do
  describe '#render_page_hierarchy' do
    context 'when a page has no child elements' do
      let(:page1) {create(:pages)}
      let(:page2) {create(:pages)}

      it 'render page tree without subpages' do
        res = helper.render_page_hierarchy([page1, page2])
        expected = "<ul class=\"nav flex-column\"><li class=\"nav-item\"><a href=\"#{page1.name}\">#{page1.title}</a></li><li class=\"nav-item\"><a href=\"#{page2.name}\">#{page2.title}</a></li></ul>"
        expect(res).to eq(expected)
      end
    end

    context 'when page has children' do
      let!(:page1) {create(:pages)}
      let!(:page2) {create(:pages)}
      let!(:page3) {create(:pages, parent_id: '1')}
      let!(:page4) {create(:pages, parent_id: '3')}

      it 'render page tree with subpages' do
        res = helper.render_page_hierarchy([page1, page2])
        expected = "<ul class=\"nav flex-column\"><li class=\"nav-item\"><a href=\"#{page1.name}\">#{page1.title}</a></li><ul class=\"nav flex-column nested_nav\"><li class=\"nav-item\"><a href=\"#{page1.name}/#{page3.name}\">#{page3.title}</a></li><ul class=\"nav flex-column nested_nav\"><li class=\"nav-item\"><a href=\"#{page1.name}/#{page3.name}/#{page4.name}\">#{page4.title}</a></li></ul></ul><li class=\"nav-item\"><a href=\"#{page2.name}\">#{page2.title}</a></li></ul>"
        expect(res).to eq(expected)
      end

      it 'rendering tree of subpages of a single page' do
        cur_page = Page.find_by(id: 1)
        res = helper.render_page_hierarchy(cur_page.children, "#{cur_page.name}/")
        expected = "<ul class=\"nav flex-column\"><li class=\"nav-item\"><a href=\"#{page1.name}/#{page3.name}\">#{page3.title}</a></li><ul class=\"nav flex-column nested_nav\"><li class=\"nav-item\"><a href=\"#{page1.name}/#{page3.name}/#{page4.name}\">#{page4.title}</a></li></ul></ul>"
        expect(res).to eq(expected)
      end
    end

  end

  describe '#get_formatted_text_page' do
    it 'formats text (bold, italics, links)' do
      text = '*[bold]* \\\\[italic]\\\\ ((name1/name2/name3 [ссылка]))'
      res = helper.get_formatted_text_page(text)
      expect(res).to eq("<strong>bold</strong> <em>italic</em> <a href='/name1/name2/name3'>[ссылка]</a>")
    end
  end
end
