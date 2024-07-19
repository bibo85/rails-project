class PagesController < ApplicationController

  def index
    @pages = Page.all
  end

  def add
    @page = Page.new
  end

  def show
    @page = Page.find(params[:id])
  end

  def new
    @page = Page.new
    @page[:name] = pages_path
    puts @page.inspect
  end


  private

  def page_params
    params.require(:page).permit(:name, :title, :body, :parent_id)
  end

  def get_parent_id
    puts params[:name]
  end

end
