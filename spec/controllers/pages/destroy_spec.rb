# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe 'DELETE #destroy' do

    context 'when a page without children is deleted' do

      context 'when is the root page' do
        let!(:page1) {create(:pages)}

        before {delete :destroy, params: {id: page1.name}}

        it 'deletes the requested root page' do
          expect(Page.count).to eq(0)
        end

        it 'redirect to the root page' do
          expect(response).to redirect_to(root_path)
        end

        it 'page was not found' do
          page_new = create(:pages)
          delete :destroy, params: {id: "#{page_new.name}f"}
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'when is it a child page' do
        let!(:page1) {create(:pages)}
        let!(:page2) {create(:pages, parent_id: page1.id)}

        before {delete :destroy, params: {path: page1.name, id: page2.name}}

        it 'deletes the requested child page' do
          expect(Page.count).to eq(1)
        end

        it 'redirect to the root page' do
          expect(response).to redirect_to(root_path)
        end

        it 'page was not found' do
          page1_new = create(:pages)
          page2_new = create(:pages, parent_id: page1_new.id)

          delete :destroy, params: {id: "#{page2_new.name}f"}
          expect(response).to have_http_status(:not_found)
        end

      end

    end

    context 'when a page with children is deleted' do

      let!(:page1) {create(:pages)}
      let!(:page2) {create(:pages)}
      let!(:page3) {create(:pages, parent_id: page1.id)}
      let!(:page4) {create(:pages, parent_id: page3.id)}

      before {delete :destroy, params: {id: page1.name}}

      it 'deletes the selected page and all child pages' do
        expect(Page.count).to eq(1)
      end

      it 'redirect to the root page' do
        expect(response).to redirect_to(root_path)
      end

      it 'page was not found' do
        create(:pages, parent_id: page2.id)
        delete :destroy, params: {id: "#{page2.name}f"}
        expect(response).to have_http_status(:not_found)
      end

    end

  end

end
