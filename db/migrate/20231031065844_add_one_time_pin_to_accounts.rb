class AddOneTimePinToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :one_time_pin, :string
  end
end
