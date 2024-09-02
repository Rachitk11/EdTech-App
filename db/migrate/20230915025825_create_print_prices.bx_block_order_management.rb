# frozen_string_literal: true
# This migration comes from bx_block_order_management (originally 20201204141741)

class CreatePrintPrices < ActiveRecord::Migration[6.0]
  def change
    create_table :print_prices do |t|
      t.string :page_size
      t.string :colors
      t.float :single_side
      t.float :double_side
      t.timestamps
    end
  end
end
