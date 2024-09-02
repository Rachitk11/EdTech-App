# This migration comes from bx_block_fedex_integration (originally 20201008085954)
class CreateBxBlockFedexIntegrationCodValues < ActiveRecord::Migration[6.0]
  def change
    create_table :cod_values do |t|
      t.references :shipment, null: false, foreign_key: true
      t.float :amount
      t.string :currency, default: "RS"

      t.timestamps
    end
  end
end
