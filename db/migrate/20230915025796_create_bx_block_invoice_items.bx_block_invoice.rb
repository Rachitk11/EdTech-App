# This migration comes from bx_block_invoice (originally 20230220131421)
class CreateBxBlockInvoiceItems < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_invoice_items do |t|
      t.bigint :order_id
      t.string :item_name
      t.float :item_unit_price
      t.timestamps
    end
  end
end
