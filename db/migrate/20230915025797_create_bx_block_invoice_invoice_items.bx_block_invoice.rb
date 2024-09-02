# This migration comes from bx_block_invoice (originally 20230222092420)
class CreateBxBlockInvoiceInvoiceItems < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_invoice_invoice_items do |t|
      t.bigint :item_id
      t.bigint :invoice_id
      t.timestamps
    end
  end
end
