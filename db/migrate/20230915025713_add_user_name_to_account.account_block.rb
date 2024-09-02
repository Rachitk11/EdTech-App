# This migration comes from account_block (originally 20201008104409)
class AddUserNameToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :user_name, :string
  end
end
