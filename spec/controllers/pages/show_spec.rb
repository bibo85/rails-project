# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe 'GET #show' do

    let!(:page1) { create(:pages) }

    before {get :show, params: {id: page1.name}}

    it 'return http success' do
      expect(response).to have_http_status(:success)
    end

    it 'used correct template' do
      expect(response).to render_template(:show)
    end

    it 'assign correctly context @page' do
      expect(assigns(:page)).to eq(page1)
    end
  end
end