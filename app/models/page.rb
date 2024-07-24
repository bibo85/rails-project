# frozen_string_literal: true

class Page < ApplicationRecord
  has_ancestry

  # belongs_to :parent, class_name: "Page", optional: true
  # has_many :children, class_name: "Page", foreign_key: "parent_id", dependent: :destroy

  validates :name, presence: true, format: {
    with: /\A[a-zA-Zа-яА-я_]+\z/,
    message: "Доступны только английские и русские буквы, а также знак нижнего подчеркивания"
  }
  validates :title, presence: true, length: {minimum: 2, maximum: 150}
  validates :body, presence: true, length: {minimum: 2}

end
