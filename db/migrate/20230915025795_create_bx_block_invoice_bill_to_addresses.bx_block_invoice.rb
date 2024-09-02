# This migration comes from bx_block_invoice (originally 20230220125111)
class CreateBxBlockInvoiceBillToAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_invoice_bill_to_addresses do |t|
      t.string :name
      t.string :company_name
      t.string :address
      t.string :city
      t.string :zip_code
      t.string :phone_number
      t.string :email
      t.bigint :order_id
      t.timestamps
    end
  end
end
