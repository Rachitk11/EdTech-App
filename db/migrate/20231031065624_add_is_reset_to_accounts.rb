class AddIsResetToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :is_reset, :boolean
  end
end
