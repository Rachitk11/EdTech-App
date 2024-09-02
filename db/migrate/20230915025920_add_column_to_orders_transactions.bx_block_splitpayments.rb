# This migration comes from bx_block_splitpayments (originally 20230618100333)
class AddColumnToOrdersTransactions < ActiveRecord::Migration[6.0]
  def change
  	add_column :shopping_cart_orders, :is_split, :boolean, default: false
  	add_column :shopping_cart_orders, :split_detail, :text
  	add_column :transactions, :is_split, :boolean, default: false
  	add_column :transactions, :split_detail, :text
  end
end
