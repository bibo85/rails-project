# frozen_string_literal: true

module ApplicationHelper
  def full_title(page_title = '')
    page_title.presence || 'Rails project'
  end
end
