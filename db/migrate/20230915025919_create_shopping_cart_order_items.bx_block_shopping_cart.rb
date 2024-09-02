# This migration comes from bx_block_shopping_cart (originally 20211217083856)
class CreateShoppingCartOrderItems < ActiveRecord::Migration[6.0]
  def change
    create_table :shopping_cart_order_items do |t|
      t.integer :order_id
      t.integer :catalogue_id
      t.float :price
      t.integer :quantity, default: 0
      t.boolean :taxable, default: false
      t.float :taxable_value, default: 0
      t.float :other_charges

      t.timestamps
    end
  end
end
