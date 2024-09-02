# This migration comes from bx_block_payments (originally 20210316075542)
class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :order_id
      t.string :razorpay_order_id
      t.string :razorpay_payment_id
      t.string :razorpay_signature
      t.integer :account_id
      t.integer :status

      t.timestamps
    end
  end
end
