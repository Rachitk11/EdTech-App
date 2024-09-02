# This migration comes from bx_block_invoice (originally 20230220111402)
class CreateBxBlockInvoice < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_invoice_invoices do |t|
      t.references :order
      t.string :invoice_number
      t.date :invoice_date
      t.float :total_amount
      t.string :company_address
      t.string :company_city
      t.string :company_zip_code
      t.string :company_phone_number
      t.string :bill_to_name
      t.string :bill_to_company_name
      t.string :bill_to_address
      t.string :bill_to_city
      t.string :bill_to_zip_code
      t.string :bill_to_phone_number
      t.string :bill_to_email
      t.string :item_name
      t.float :item_unit_price
      t.timestamps
    end
  end
end
