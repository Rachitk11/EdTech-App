# This migration comes from account_block (originally 20221108151340)
class RemoveStripDetailsFromAccounts < ActiveRecord::Migration[6.0]
  def change
    remove_column :accounts, :stripe_id
    remove_column :accounts, :stripe_subscription_id
    remove_column :accounts, :stripe_subscription_date
  end
end
