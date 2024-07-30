# frozen_string_literal: true

# Класс GetPageId отвечает за поиск id конечной страницы из указанного пути
class GetPageId < ApplicationService
  def initialize(params)
    @path = parse_path(params)
  end

  # Метод возвращает id конечной страницы. Если путь некорректный, выбрасывается исключение
  # ActiveRecord::RecordNotFound и пользователь перенаправляется на страницу 404.
  # return id [Integer] id конечной страницы из пути
  #
  # @example
  #   @path = "name1/name2"
  #   id = 2
  def call
    cur_path = '/'
    id = nil
    @path.each do |name_page|
      raise ActiveRecord::RecordNotFound unless Page.exists?(name: name_page, ancestry: cur_path)

      page = Page.find_by(name: name_page, ancestry: cur_path)
      cur_path = "#{cur_path}#{page.id}/"
      id = page.id
    end
    id
  end

  private

  # Метод принимает на вход параметры запроса и возвращает путь к указанной в параметрах странице
  # @param params [ActionController::Parameters] параметры запроса
  #
  # @return path [String] путь к странице
  #
  # @example
  #   params = {"controller"=>"pages",
  #             "action"=>"show",
  #             "path"=>"name1/name2",
  #             "id"=>"name3"}
  #   path = "name1/name2/name3"
  def parse_path(params)
    path = if params[:path].present?
             [params[:path], params[:id]].join('/')
           else
             params[:id]
           end
    path.split('/')
  end
end
