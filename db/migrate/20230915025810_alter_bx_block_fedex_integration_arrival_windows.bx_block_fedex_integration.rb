# This migration comes from bx_block_fedex_integration (originally 20201013095109)
class AlterBxBlockFedexIntegrationArrivalWindows < ActiveRecord::Migration[6.0]
  def change
    remove_column :arrival_windows, :delivery_id
    remove_column :arrival_windows, :pickup_id
    add_column :arrival_windows, :addressable_id, :integer
  end
end
