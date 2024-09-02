# This migration comes from account_block (originally 20210601110615)
class AddIsBlacklistedToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :is_blacklisted, :boolean, default: false
  end
end
