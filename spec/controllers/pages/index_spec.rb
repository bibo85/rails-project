# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET index' do

    let!(:page1) {create(:pages)}
    let!(:page2) {create(:pages)}
    let!(:page3) {create(:pages, parent_id: '1')}
    let!(:page4) {create(:pages, parent_id: '3')}

    it 'return http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'used correct template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns correctly context @pages' do
      get :index
      expect(assigns(:pages)).to eq([page1, page2])
    end
  end
end
