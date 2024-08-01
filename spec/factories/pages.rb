# frozen_string_literal: true

FactoryBot.define do
  factory :pages, class: 'Page' do
    sequence(:name, %w[first second third fourth fifth].cycle) { |n| "name_#{n}" }
    sequence(:title, %w[first second third fourth fifth].cycle) { |n| "#{n}_title" }
    sequence(:body, %w[first second third fourth fifth].cycle) { |n| "#{n}_body" }
    parent_id { "" }
  end
end
