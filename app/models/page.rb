# frozen_string_literal: true

# has_ancestry добавляет к модели родословную. После этого модель - дерево.
class Page < ApplicationRecord
  has_ancestry

  validates :name, presence: true, format: {
    with: /\A[a-zA-Zа-яА-я_]+\z/,
    message: '- в поле доступны только английские и русские буквы, а также знак нижнего подчеркивания'
  }
  validates :title, presence: true
  validates :body, presence: true

  validates :name, uniqueness: { scope: [:ancestry], message: '- поле уже используется на этом уровне вложенности' }
end
