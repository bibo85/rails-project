# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::InvalidAuthenticityToken, with: :token_error
  add_flash_types :success, :danger

  private

  def not_found(exception)
    render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
  end

  def token_error(exception)
    puts request.referrer.inspect
    redirect_to request.referrer, danger: "Ошибка, повторите отправку формы"
  end
end
