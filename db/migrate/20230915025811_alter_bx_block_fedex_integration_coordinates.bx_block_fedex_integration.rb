# This migration comes from bx_block_fedex_integration (originally 20201013095551)
class AlterBxBlockFedexIntegrationCoordinates < ActiveRecord::Migration[6.0]
  def change
    remove_column :coordinates, :delivery_id
    remove_column :coordinates, :pickup_id
    add_column :coordinates, :addressable_id, :integer
  end
end
