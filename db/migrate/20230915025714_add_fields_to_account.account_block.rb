# This migration comes from account_block (originally 20210128090458)
class AddFieldsToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :platform, :string
    add_column :accounts, :user_type, :string
  end
end
