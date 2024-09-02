# This migration comes from bx_block_fedex_integration (originally 20201008091043)
class CreateBxBlockFedexIntegrationPickups < ActiveRecord::Migration[6.0]
  def change
    create_table :pickups do |t|
      t.references :shipment, null: false, foreign_key: true
      t.text :address
      t.text :address2
      t.string :city
      t.string :country
      t.string :email
      t.string :name
      t.string :phone

      t.timestamps
    end
  end
end
