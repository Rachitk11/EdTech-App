# This migration comes from bx_block_shopping_cart (originally 20200831114430)
class CreateShoppingCartOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :shopping_cart_orders do |t|
      t.references :customer
      t.integer :address_id
      t.integer :status
      t.float :total_fees
      t.integer :total_items
      t.float :total_tax

      t.timestamps
    end
  end
end
