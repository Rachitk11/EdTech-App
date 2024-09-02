# frozen_string_literal: true
# This migration comes from bx_block_categories (originally 20210610112559)

class CreateAccountCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :account_categories do |t|
      t.integer :account_id
      t.integer :category_id

      t.timestamps
    end
  end
end
