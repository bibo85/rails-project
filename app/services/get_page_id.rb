# frozen_string_literal: true

class GetPageId < ApplicationService

  def initialize(params)
    @path = parse_path(params)
  end

  def call
    cur_path = "/"
    id = nil
    @path.each do |name_page|
      unless Page.exists?(name: name_page, ancestry: cur_path)
        raise ActiveRecord::RecordNotFound
      end
      page = Page.find_by(name: name_page, ancestry: cur_path)
      cur_path = "#{cur_path}#{page.id}/"
      id = page.id
    end
    id
  end

  private

  def parse_path(params)
    path = if params[:path].present?
      [params[:path], params[:id]].join("/")
    else
      params[:id]
    end
    path.split("/")
  end
end
