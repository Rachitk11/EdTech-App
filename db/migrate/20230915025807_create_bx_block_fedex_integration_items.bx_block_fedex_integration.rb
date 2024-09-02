# This migration comes from bx_block_fedex_integration (originally 20201008092215)
class CreateBxBlockFedexIntegrationItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.references :shipment, null: false, foreign_key: true
      t.string :ref_id
      t.float :weight
      t.integer :quantity
      t.boolean :stackable, default: true
      t.integer :item_type, default: 0

      t.timestamps
    end
  end
end
