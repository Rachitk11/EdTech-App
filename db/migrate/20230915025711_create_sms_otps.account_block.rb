# This migration comes from account_block (originally 20191212190350)
class CreateSmsOtps < ActiveRecord::Migration[6.0]
  def change
    create_table :sms_otps do |t|
      t.string :full_phone_number
      t.integer :pin
      t.boolean :activated, null: false, default: false
      t.timestamp :valid_until
      t.timestamps
    end
  end
end
