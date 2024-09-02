# frozen_string_literal: true
# This migration comes from bx_block_order_management (originally 20201026124442)

class CreateBxBlockOrderManagementDeliveryAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :delivery_addresses do |t|
      t.references :account, null: false, foreign_key: true
      t.string :address
      t.string :name
      t.string :flat_no
      t.string :zip_code
      t.string :phone_number
      t.datetime :deleted_at
      t.float :latitude
      t.float :longitude
      t.boolean :residential, default: true
      t.string :city
      t.string :state_code
      t.string :country_code
      t.string :state
      t.string :country
      t.string :address_line_2
      t.string :address_type, default: "home"
      t.string :address_for, default: "shipping"
      t.boolean :is_default, default: false
      t.string :landmark

      t.timestamps
    end
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Naming/VariableNumber
