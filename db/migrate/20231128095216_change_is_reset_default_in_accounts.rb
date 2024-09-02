class ChangeIsResetDefaultInAccounts < ActiveRecord::Migration[6.0]
  def change
  	change_column_default :accounts, :is_reset, false
  end
end
