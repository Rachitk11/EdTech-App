# This migration comes from bx_block_catalogue (originally 20201008093428)
class CreateCatalogues < ActiveRecord::Migration[6.0]
  def change
    create_table :catalogues do |t|
      t.references :category, null: false, foreign_key: true
      t.references :sub_category, null: false, foreign_key: true
      t.references :brand, null: true, foreign_key: true
      t.string :name
      t.string :sku
      t.string :description
      t.datetime :manufacture_date
      t.float :length
      t.float :breadth
      t.float :height
      t.integer :availability
      t.integer :stock_qty
      t.decimal :weight
      t.float :price
      t.boolean :recommended
      t.boolean :on_sale
      t.decimal :sale_price
      t.decimal :discount

      t.timestamps
    end
  end
end
