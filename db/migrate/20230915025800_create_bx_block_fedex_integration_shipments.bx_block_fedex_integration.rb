# This migration comes from bx_block_fedex_integration (originally 20201008085332)
class CreateBxBlockFedexIntegrationShipments < ActiveRecord::Migration[6.0]
  def change
    create_table :shipments do |t|
      t.references :create_shipment, null: false, foreign_key: true
      t.string :ref_id
      t.boolean :full_truck, default: false
      t.text :load_description

      t.timestamps
    end
  end
end
