# frozen_string_literal: true

class PagesController < ApplicationController

  def index
    @pages = Page.where(ancestry: "/")
  end

  def show
    @page = Page.find get_page_id_from_path
  end

  def new
    # Получение будущего родителя для новой страницы с проверкой, что путь существует.
    # Если некорректный путь, то выкинет исключение ActiveRecord::RecordNotFound и переведет на 404 страницу
    @page = Page.new(parent_id: get_page_id_from_path)
  end

  def create
    @page = Page.new page_params
    if @page.save
      redirect_to root_path, status: :see_other, success: "Страница успешно создана"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def page_params
    params.require(:page).permit(:id, :name, :title, :body, :parent_id)
  end

  def get_page_id_from_path
    # Метод возвращает id конечной страницы из текущего пути страницы
    # Если конечная страница не найдена (путь некорректный) выкидывает исключение ActiveRecord::RecordNotFound
    return "" if params[:path].nil? && params[:id].nil?

    page_id = GetPageId.call(params)
    if page_id.present?
      puts "ID страницы"
      puts page_id
      return page_id
    end
    raise ActiveRecord::RecordNotFound
  end

end
