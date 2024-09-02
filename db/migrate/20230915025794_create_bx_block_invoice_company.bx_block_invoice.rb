# This migration comes from bx_block_invoice (originally 20230220123437)
class CreateBxBlockInvoiceCompany < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_invoice_companies do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :zip_code
      t.string :phone_number
      t.string :email
      t.timestamps
    end
  end
end
