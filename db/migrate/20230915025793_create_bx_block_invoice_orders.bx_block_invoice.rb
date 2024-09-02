# This migration comes from bx_block_invoice (originally 20230220114653)
class CreateBxBlockInvoiceOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_invoice_orders do |t|
      t.string :order_number
      t.datetime :order_date
      t.string :customer_name
      t.string :customer_address
      t.string :customer_phone_number
      t.string :email
      t.bigint :company_id
      t.timestamps
    end
  end
end
