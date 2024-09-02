# frozen_string_literal: true
# This migration comes from bx_block_order_management (originally 20201019090806)

class CreateBxBlockOrderManagementOrderTrackings < ActiveRecord::Migration[6.0]
  def change
    create_table :order_trackings do |t|
      t.references :parent, polymorphic: true
      t.integer :tracking_id
      t.timestamps
    end
  end
end
