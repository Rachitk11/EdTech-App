# frozen_string_literal: true
# This migration comes from bx_block_profile_bio (originally 20201211101801)

# create profile bios
# rubocop:disable Metrics/MethodLength, Metrics/AbcSize
class CreateProfileBios < ActiveRecord::Migration[6.0]
  def change
    create_table :profile_bios do |t|
      t.integer :account_id
      t.string :height
      t.string :weight
      t.integer :height_type
      t.integer :weight_type
      t.integer :body_type
      t.integer :mother_tougue
      t.integer :religion
      t.integer :zodiac
      t.integer :marital_status
      t.string :languages, array: true
      t.text :about_me
      t.string :personality, array: true
      t.string :interests, array: true
      t.integer :smoking
      t.integer :drinking
      t.integer :looking_for

      t.timestamps
    end
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize
