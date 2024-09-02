# This migration comes from bx_block_account_groups (originally 20220519124318)
class AccountGroupsCreateAccountGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :account_groups_account_groups do |t|
      t.references :account, null: false, foreign_key: true
      t.references :account_groups_group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
