# This migration comes from bx_block_account_groups (originally 20220519115534)
class AccountGroupsCreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :account_groups_groups do |t|
      t.string :name
      t.jsonb :settings
      t.timestamps
    end
  end
end
