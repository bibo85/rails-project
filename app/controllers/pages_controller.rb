# frozen_string_literal: true

# Контроллер отвечает за управление страницами сайта.
class PagesController < ApplicationController

  before_action :set_page, only: [:show, :edit, :destroy]

  def index
    @pages = Page.where(ancestry: "/")
  end

  def show
  end

  # Метод отображает форму для создания новой головной или дочерней страницы.
  # Создание головной страницы запускается, если в params не приходит :path или :id.
  # Если в params есть :path и/или :id, запускается процесс создания дочерней страницы.
  # @example
  #   Переход по адресу /name1/name2/name3/add отображает форму для создания дочерней страницы с родителем name3.
  #   (Parameters: {"path"=>"name1/name2", "id"=>"name3"})
  def new
    @page = Page.new(parent_id: get_page_id_from_path)
  end

  def create
    @page = Page.new page_params
    if @page.save
      path_to_page = get_path_to_redirect(@page.path_ids[0..-2])
      redirect_to page_path(path: path_to_page, id: @page.name), status: :see_other, success: "Страница успешно создана"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @page = Page.find params[:id]
    if @page.update page_params
      path_to_page = get_path_to_redirect(@page.path_ids[0..-2])
      redirect_to page_path(path: path_to_page, id: @page.name), status: :see_other, success: "Страница успешно обновлена"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @page.destroy
    redirect_to root_path, status: :see_other, success: "Страница успешно удалена"
  end

  private

  # Метод устанавливает текущею страницу. Если путь некорректный выбрасывается исключение ActiveRecord::RecordNotFound
  # и пользователь переводится на страницу 404.
  def set_page
    @page = Page.find get_page_id_from_path
  end

  def page_params
    params.require(:page).permit(:id, :name, :title, :body, :parent_id)
  end

  # Метод возвращает id конечной страницы. Адрес страницы получает из params[:path] и params[:id]. Например,
  # переход по адресу /name1/name2/name3/add => Parameters: {"path"=>"name1/name2", "id"=>"name3"}.
  # Если происходит переход с главной страницы, возвращает пустую строку.
  # Если конечная страница не найдена (путь некорректный), выбрасывается исключение ActiveRecord::RecordNotFound и
  # пользователь переводится на страницу 404.
  #
  # @return [Integer, String] возвращает id, если путь к странице корректный, и пустую строку, если был переход с
  #                           главной страницы.
  def get_page_id_from_path
    return "" if params[:path].nil? && params[:id].nil?

    page_id = GetPageId.call(params)
    if page_id.present?
      return page_id
    end
    raise ActiveRecord::RecordNotFound
  end

  # Метод получает на вход массив из id страниц и возвращает путь к странице (path), состоящий из полей name страниц
  # модели Page. Если массив пустой, возвращает nil.
  #
  # @param path_ids [Array[Integer]] массив из id страниц
  # @return path [String, NilClass] путь к странице. Если path_ids пустой, возвращает nil
  # @example
  #   path_ids = [1, 2]
  #   path = "name1/name2"
  # @see Page
  def get_path_to_redirect(path_ids)
    return nil unless path_ids.present?

    path = []
    path_ids.each do |id|
      path << Page.find(id).name
    end
    path.join("/")
  end

end
