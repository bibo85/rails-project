# frozen_string_literal: true

class PagesController < ApplicationController

  before_action :set_page, only: [:show, :edit, :destroy]

  def index
    @pages = Page.where(ancestry: "/")
  end

  def show
  end

  def new
    # Получение будущего родителя для новой страницы с проверкой, что путь существует.
    # Если некорректный путь, то выкинет исключение ActiveRecord::RecordNotFound и переведет на 404 страницу
    @page = Page.new(parent_id: get_page_id_from_path)
  end

  def create
    @page = Page.new page_params
    if @page.save
      path_to_page = get_path_to_redirect(@page.path_ids)
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
      path_to_page = get_path_to_redirect(@page.path_ids)
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

  def set_page
    @page = Page.find get_page_id_from_path
  end

  def page_params
    params.require(:page).permit(:id, :name, :title, :body, :parent_id)
  end

  def get_page_id_from_path
    # Метод возвращает id конечной страницы из текущего пути страницы
    # Если конечная страница не найдена (путь некорректный) выкидывает исключение ActiveRecord::RecordNotFound
    return "" if params[:path].nil? && params[:id].nil?

    page_id = GetPageId.call(params)
    if page_id.present?
      return page_id
    end
    raise ActiveRecord::RecordNotFound
  end

  def get_path_to_redirect(path_ids)
    return nil if path_ids.size == 1

    path = []
    path_ids.each do |id|
      path << Page.find(id).name
    end
    path[0..-2].join("/")
  end

end
