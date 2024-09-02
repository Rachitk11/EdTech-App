# frozen_string_literal: true
# This migration comes from bx_block_categories (originally 20210318055159)

class CreateBxBlockCategoriesUserCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :user_categories do |t|
      t.references :account, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
