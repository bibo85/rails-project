module ApplicationHelper

  def full_title(page_title = '')
    if page_title.present?
      page_title
    else
      'Rails project'
    end
  end
end
