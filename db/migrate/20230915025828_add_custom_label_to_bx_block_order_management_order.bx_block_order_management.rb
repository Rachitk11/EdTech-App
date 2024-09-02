# frozen_string_literal: true
# This migration comes from bx_block_order_management (originally 20220608064607)

class AddCustomLabelToBxBlockOrderManagementOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :order_management_orders, :custom_label, :string
  end
end
