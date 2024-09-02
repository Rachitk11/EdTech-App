class AddPinToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :pin, :string
  end
end
