# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GetPageId do

  describe '#call' do

    let!(:page1) { create(:pages) }
    let!(:page2) { create(:pages, parent_id: '1') }
    let!(:page3) { create(:pages, parent_id: '2') }
    let(:service1) { GetPageId.new({ path: "#{page1.name}/#{page2.name}", id: "#{page3.name}" }) }
    let(:service2) { GetPageId.new({id: "#{page1.name}" }) }
    let(:service3) { GetPageId.new({ path: "#{page1.name}a/#{page2.name}", id: "#{page3.name}" }) }
    let(:service4) { GetPageId.new({id: "#{page1.name}a" }) }

    context 'correct params' do

      it 'params have path and id' do
        result = service1.call
        expect(result).to eq(3)
      end

      it 'params have only id' do
        result = service2.call
        expect(result).to eq(1)
      end

    end

    context 'incorrect params' do

      it 'params have path and id' do
        expect do
          service3.call
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'params have only id' do
        expect do
          service4.call
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

  end

end
