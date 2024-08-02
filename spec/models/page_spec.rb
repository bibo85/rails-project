# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Page, type: :model do

  describe 'validations' do

    it ''

    context 'unique page names at the same nesting level relative to the parent' do

      let!(:page1) {create(:pages)}

      it 'is valid' do
        page2 = create(:pages)
        expect(page2).to be_valid
      end

      it 'is invalid' do
        page2 = create(:pages, name: "test_page", parent_id: page1.id)
        page3 = build(:pages, name: "test_page", parent_id: page1.id)
        expect(page3).not_to be_valid

      end

    end

  end

end
