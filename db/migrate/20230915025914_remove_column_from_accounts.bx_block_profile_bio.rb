# This migration comes from bx_block_profile_bio (originally 20221215112214)
class RemoveColumnFromAccounts < ActiveRecord::Migration[6.0]
  def change
    remove_column :accounts, :is_paid, :boolean
  end
end
