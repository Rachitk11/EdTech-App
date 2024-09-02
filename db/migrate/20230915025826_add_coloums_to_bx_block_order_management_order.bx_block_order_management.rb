# frozen_string_literal: true
# This migration comes from bx_block_order_management (originally 20220331054828)

class AddColoumsToBxBlockOrderManagementOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :order_management_orders, :charged, :boolean
    add_column :order_management_orders, :invoiced, :boolean
    add_column :order_management_orders, :invoice_id, :string
  end
end
