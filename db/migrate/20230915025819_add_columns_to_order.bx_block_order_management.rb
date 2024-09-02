# frozen_string_literal: true
# This migration comes from bx_block_order_management (originally 20201019114320)

class AddColumnsToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :order_management_orders, :is_group, :boolean, default: true
    add_column :order_management_orders, :is_availability_checked, :boolean, default: false
    add_column :order_management_orders, :shipping_charge, :decimal
    add_column :order_management_orders, :shipping_discount, :decimal
    add_column :order_management_orders, :shipping_net_amt, :decimal
    add_column :order_management_orders, :shipping_total, :decimal
    add_column :order_management_orders, :total_tax, :float
  end
end
