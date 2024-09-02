# frozen_string_literal: true
# This migration comes from bx_block_categories (originally 20210618102700)

class AddLightIconToCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :light_icon, :string
    add_column :categories, :light_icon_active, :string
    add_column :categories, :light_icon_inactive, :string
    add_column :categories, :dark_icon, :string
    add_column :categories, :dark_icon_active, :string
    add_column :categories, :dark_icon_inactive, :string
  end
end
