# This migration comes from bx_block_splitpayments (originally 20230705072639)
class CreateBxBlockSplitpaymentsOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_splitpayments_orders do |t|

      t.timestamps
    end
  end
end
