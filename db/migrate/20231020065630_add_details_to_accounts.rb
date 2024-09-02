class AddDetailsToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :publication_house_name, :string
    add_column :accounts, :bank_account_number, :string
    add_column :accounts, :ifsc_code, :string
  end
end
