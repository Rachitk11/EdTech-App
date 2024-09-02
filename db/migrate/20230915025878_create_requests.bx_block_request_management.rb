# This migration comes from bx_block_request_management (originally 20210106065547)
class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.integer :sender_id
      t.integer :status, default: 0
      t.integer :account_group_id
      t.string :request_text
      t.string :rejection_reason

      t.timestamps
    end
  end
end
