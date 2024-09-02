# This migration comes from bx_block_multipageforms2 (originally 20230220050821)
class CreateBxBlockMultipageforms2UserProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_multipageforms2_user_profiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :email
      t.string :gender
      t.string :country
      t.integer :industry
      t.text :message

      t.timestamps
    end
  end
end
