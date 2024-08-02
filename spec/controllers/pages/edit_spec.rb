# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'Get #edit' do

    context 'when the root page is being edited' do
      let(:page) {create(:pages)}

      before { get :edit, params: {id: page.name}}

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'used correct template' do
        expect(response).to render_template(:edit)
      end

      it 'assign correctly context in @page' do
        expect(assigns(:page)).to eq(page)
      end

      it 'page was not found' do
        get :edit, params: {id: "#{page.name}f"}
        expect(response).to have_http_status(:not_found)
      end

    end

    context 'when the child page is being edited' do
      let!(:page1) {create(:pages)}
      let!(:page2) {create(:pages, parent_id: page1.id)}

      before {get :edit, params: {path: page1.name, id: page2.name}}

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'used correct template' do
        expect(response).to render_template(:edit)
      end

      it 'assign correctly context in @page' do
        expect(assigns(:page)).to eq(page2)
      end

      it 'page was not found' do
        get :edit, params: {path: "#{page1.name}f", id: "#{page2.name}"}
        expect(response).to have_http_status(:not_found)
      end

    end

  end
end