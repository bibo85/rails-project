# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe 'PATCH #update' do

    context 'with valid params' do

      context 'when we update the root page' do

        let!(:page) { create(:pages) }
        before {patch :update, params: { id: page.id, page: { title: 'New title', body: 'New body' } } }

        it 'successfully updated the page title and body' do
          page.reload
          expect(page.title).to eq('New title')
          expect(page.body).to eq('New body')
        end

        it 'redirect to the updated page' do
          expect(response).to redirect_to(page_path(id: page.name))
        end

      end

      context 'when we update the child page' do

        let!(:page1) { create(:pages) }
        let!(:page2) { create(:pages, parent_id: page1.id) }

        before { patch :update, params: { path: page1.name, id: page2.id,
                                          page: { title: 'New title', body: 'New body' } } }

        it 'successfully updated the page title and body' do
          page2.reload
          expect(page2.title).to eq('New title')
          expect(page2.body).to eq('New body')
        end

        it 'redirect to the updated page' do
          expect(response).to redirect_to(page_path(path: page1.name, id: page2.name))
        end

      end

    end

    context 'with invalid params' do

      let( :page ) { create(:pages) }
      before { patch :update, params: { id: page.id, page: { title: '', body: ''} } }

      it 'does not update' do
        page.reload
        expect(page.title).not_to eq('')
        expect(page.body).not_to eq('')
      end

      it 're-render the edit template' do
        expect(response).to render_template(:edit)
      end

    end

  end
end
