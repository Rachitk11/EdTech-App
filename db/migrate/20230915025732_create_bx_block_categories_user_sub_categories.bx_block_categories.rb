# frozen_string_literal: true
# This migration comes from bx_block_categories (originally 20210305100511)

class CreateBxBlockCategoriesUserSubCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :user_sub_categories do |t|
      t.references :account, null: false, foreign_key: true
      t.references :sub_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
