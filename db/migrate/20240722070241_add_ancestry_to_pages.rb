# frozen_string_literal: true

class AddAncestryToPages < ActiveRecord::Migration[7.1]
  def change
    add_column :pages, :ancestry, :string
    add_index :pages, :ancestry
  end
end
