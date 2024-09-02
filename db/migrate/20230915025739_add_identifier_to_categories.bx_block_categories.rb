# frozen_string_literal: true
# This migration comes from bx_block_categories (originally 20210708104835)

class AddIdentifierToCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :identifier, :integer
    BxBlockCategories::BuildCategories.call
  end
end
