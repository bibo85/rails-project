# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'POST #create' do
    context 'when the root page is created' do

      before { post :create, params: {page: attributes_for(:pages)} }

      it 'a new page has been created' do
        before_pages_count = Page.count
        post :create, params: {page: attributes_for(:pages)}
        expect(Page.count).to eq(before_pages_count + 1)
      end

      it 'it redirect to a new created page' do
        expect(response).to redirect_to page_path(id: assigns(:page).name)
      end

    end

    context 'when a child page is created' do

      let!(:page1) {create(:pages)}
      let!(:page2) {create(:pages, parent_id: '1')}

      it 'a new page has been created' do
        before_pages_count = Page.count
        post :create, params: {page: attributes_for(:pages, path: page1.name, parent_id: page2.id)}
        expect(Page.count).to eq(before_pages_count + 1)
      end

      it 'redirect to a new page after creation' do
        post :create, params: {page: attributes_for(:pages, parent_id: page2.id)}
        expect(response).to redirect_to page_path(path: "#{page1.name}/#{page2.name}", id: assigns(:page).name)
      end
    end

    context 'with invalid data' do

      let(:page1) {create(:pages)}
      let(:page2) {create(:pages, parent_id: '1')}

      it 'a new page has not been created' do
        before_pages_count = Page.count
        post :create, params: {page: attributes_for(:pages, title: "")}
        expect(Page.count).to eq(before_pages_count)
      end

      it 're-redirect to the creation root page' do
        post :create, params: {page: attributes_for(:pages, name: "")}
        expect(response).to render_template(:new)
      end

      it 're-redirect to the creation children page' do
        post :create, params: {page: attributes_for(:pages, name: ""), path: page1.name, id: page2.name}
        expect(response).to render_template(:new)
      end
    end
  end
end