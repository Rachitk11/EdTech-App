# frozen_string_literal: true
# This migration comes from bx_block_order_management (originally 20220609132737)

class AddIndexIsBlacklistedColumnToAccount < ActiveRecord::Migration[6.0]
  def change
    add_index :accounts, :is_blacklisted
  end
end
