# frozen_string_literal: true
# This migration comes from bx_block_order_management (originally 20201014082316)

class CreateBxBlockOrderManagementOrderItems < ActiveRecord::Migration[6.0]
  def change
    create_table :order_items do |t|
      t.references :order_management_order, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :unit_price
      t.decimal :total_price
      t.decimal :old_unit_price
      t.string :status

      t.timestamps
    end
  end
end
