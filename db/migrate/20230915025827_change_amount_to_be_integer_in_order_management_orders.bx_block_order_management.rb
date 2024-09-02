# frozen_string_literal: true
# This migration comes from bx_block_order_management (originally 20220422064751)

class ChangeAmountToBeIntegerInOrderManagementOrders < ActiveRecord::Migration[6.0]
  def change
    change_column :order_management_orders, :amount, :integer
  end
end
