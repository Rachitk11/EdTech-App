# This migration comes from account_block (originally 20210819121608)
class AddStripeFieldsToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :stripe_id, :string
    add_column :accounts, :stripe_subscription_id, :string
    add_column :accounts, :stripe_subscription_date, :datetime
  end
end
