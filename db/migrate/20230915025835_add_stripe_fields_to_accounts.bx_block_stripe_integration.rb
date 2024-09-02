# This migration comes from bx_block_stripe_integration (originally 20221108151716)
class AddStripeFieldsToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :stripe_id, :string
    add_column :accounts, :stripe_subscription_id, :string
    add_column :accounts, :stripe_subscription_date, :datetime
  end
end
