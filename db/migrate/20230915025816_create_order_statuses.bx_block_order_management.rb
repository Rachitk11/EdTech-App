# frozen_string_literal: true
# This migration comes from bx_block_order_management (originally 20201019072808)

class CreateOrderStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :order_statuses do |t|
      t.string :name
      t.string :status
      t.boolean :active, default: true
      t.string :event_name
      t.string :message

      t.timestamps
    end
  end
end
