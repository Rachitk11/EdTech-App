# This migration comes from bx_block_request_management (originally 20230518133151)
class AddAccountIdToRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :account_id, :bigint
  end
end
