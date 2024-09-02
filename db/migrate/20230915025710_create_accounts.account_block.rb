# This migration comes from account_block (originally 20191202221207)
class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :first_name
      t.string :last_name
      t.string :full_phone_number
      t.integer :country_code
      t.bigint :phone_number
      t.string :email
      t.boolean :activated, null: false, default: false
      t.string :device_id
      t.text :unique_auth_id
      t.string :password_digest
      t.string :type

      t.timestamps
    end
  end
end
