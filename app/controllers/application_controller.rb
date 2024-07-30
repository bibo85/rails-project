# frozen_string_literal: true

# В контроллере обрабатываются ошибки, а также добавляются типы возможных flash сообщений
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::InvalidAuthenticityToken, with: :token_error
  add_flash_types :success, :danger

  private

  # Метод not_found используется в случае, когда страница не найдена (ошибка 404).
  # Отображает страницу public/404.html
  # @note
  #   Вызывается при получении ошибки ActiveRecord::RecordNotFound при попытке получить доступ к несуществующей
  #   странице
  def not_found(_exception)
    render file: Rails.public_path.join('404.html').to_s, status: :not_found, layout: false
  end

  # Метод token_error перенаправляет пользователя на предыдущую страницу, которую получает из request.referrer.
  # Дополнительно передает flash сообщение - danger: "Ошибка, повторите отправку формы"
  # @note
  #   Вызывается при получении ошибки ActionController::InvalidAuthenticityToken при попытке отправить некорректные
  #   данные из формы
  def token_error(_exception)
    redirect_to request.referer, danger: 'Ошибка, повторите отправку формы'
  end
end
