# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET new' do

    context 'when the root page is created' do
      before {get :new}

      it 'return https success' do
        expect(response).to have_http_status(:success)
      end

      it 'used correct template' do
        expect(response).to render_template(:new)
      end

      it 'assigns a new page to @page' do
        expect(assigns(:page)).to be_a_new(Page)
      end
    end

    context 'when a child page is created' do

      let!(:page) {create(:pages)}

      before {get :new, params: {id: page.name}}

      it 'return https success' do
        expect(response).to have_http_status(:success)
      end

      it 'used correct template' do
        expect(response).to render_template(:new)
      end

      it 'assigns a new page to @page' do
        expect(assigns(:page)).to be_a_new(Page)
      end

      it 'page was not found' do
        get :new, params: {id: "#{page.name}f"}
        expect(response).to have_http_status(:not_found)
      end

    end
  end
end
