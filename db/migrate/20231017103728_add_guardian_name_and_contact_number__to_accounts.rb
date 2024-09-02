class AddGuardianNameAndContactNumberToAccounts < ActiveRecord::Migration[6.0]
  def change
  	add_column :accounts, :guardian_name, :string
  	add_column :accounts, :guardian_contact_no, :string
  end
end
