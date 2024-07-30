# frozen_string_literal: true

class CreatePages < ActiveRecord::Migration[7.1]
  def change
    create_table :pages do |t|
      t.string :name
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
