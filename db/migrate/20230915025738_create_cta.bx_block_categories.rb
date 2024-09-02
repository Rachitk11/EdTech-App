# frozen_string_literal: true
# This migration comes from bx_block_categories (originally 20210701065848)

class CreateCta < ActiveRecord::Migration[6.0]
  def change
    create_table :cta do |t|
      t.string :headline
      t.text :description
      t.references :category
      t.string :long_background_image
      t.string :square_background_image
      t.string :button_text
      t.string :redirect_url
      t.integer :text_alignment
      t.integer :button_alignment
      t.boolean :is_square_cta
      t.boolean :is_long_rectangle_cta
      t.boolean :is_text_cta
      t.boolean :is_image_cta
      t.boolean :has_button
      t.boolean :visible_on_home_page
      t.boolean :visible_on_details_page
      t.timestamps
    end
  end
end
