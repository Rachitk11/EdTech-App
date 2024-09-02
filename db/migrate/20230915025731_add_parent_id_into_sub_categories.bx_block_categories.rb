# frozen_string_literal: true
# This migration comes from bx_block_categories (originally 20210302062021)

class AddParentIdIntoSubCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :sub_categories, :parent_id, :bigint
  end
end
