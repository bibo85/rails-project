# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Page, type: :model do

  describe 'validations' do

    describe '#name' do
      it { should_not allow_values(
                        'test1', 'test-a', 'test/', 'test*', 'test page', 'те ст', 'тест1', 'тест-ф').for(:name) }
      it { should allow_value('test_page', 'test', 'тест', 'тестовая_страница').for(:name) }
      it { should validate_presence_of(:name) }
    end

    describe '#title' do
      it { should validate_presence_of(:title) }
    end

    describe '#body' do
      it { should validate_presence_of(:body) }
    end

    context 'unique page names at the same nesting level relative to the parent' do

      let!(:page1) {FactoryBot.create(:pages)}

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
