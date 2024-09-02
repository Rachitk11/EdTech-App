# This migration comes from bx_block_fedex_integration (originally 20201008064916)
class CreateBxBlockFedexIntegrationCreateShipments < ActiveRecord::Migration[6.0]
  def change
    create_table :create_shipments do |t|
      t.boolean :auto_assign_drivers, default: false
      t.string :requested_by
      t.string :shipper_id
      t.string :waybill


      t.timestamps
    end
  end
end
