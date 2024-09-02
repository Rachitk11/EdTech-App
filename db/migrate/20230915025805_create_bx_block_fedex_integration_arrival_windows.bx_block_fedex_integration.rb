# This migration comes from bx_block_fedex_integration (originally 20201008091540)
class CreateBxBlockFedexIntegrationArrivalWindows < ActiveRecord::Migration[6.0]
  def change
    create_table :arrival_windows do |t|
      t.references :delivery, null: true, foreign_key: true
      t.references :pickup, null: true, foreign_key: true
      t.datetime :begin_at
      t.datetime :end_at
      t.boolean :exclude_begin, default: true
      t.boolean :exclude_end, default: true

      t.timestamps
    end
  end
end
