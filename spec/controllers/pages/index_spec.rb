# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET index' do
    # проверка ответа 200
    it 'return http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    # проверка корректности используемого шаблона
    it 'used correct template' do
      get :index
      expect(response).to render_template(:index)
    end

    # проверка контекста страницы
    it 'assigns correctly context @pages' do
      pages = %w[name_first name_second name_third].map do |name|
        FactoryBot.create(:page, name:, title: "#{name}_title", body: "#{name}_body")
      end

      get :index
      expect(assigns(:pages)).to eq(pages)
    end
  end
end
