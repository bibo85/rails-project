# frozen_string_literal: true

class Page < ApplicationRecord
  has_ancestry

  validates :name, presence: true, format: {
    with: /\A[a-zA-Zа-яА-я_]+\z/,
    message: "- в поле доступны только английские и русские буквы, а также знак нижнего подчеркивания"
  }
  validates :title, presence: true, length: {minimum: 2, maximum: 150}
  validates :body, presence: true, length: {minimum: 2}

  validates :name, uniqueness: {scope: [:ancestry], message: "- поле уже используется на этом уровне вложенности"}

end
