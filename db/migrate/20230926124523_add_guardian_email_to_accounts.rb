class AddGuardianEmailToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :guardian_email, :string
  end
end
