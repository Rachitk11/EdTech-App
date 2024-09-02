# This migration comes from bx_block_catalogue (originally 20201010075427)
class CreateCatalogueVariants < ActiveRecord::Migration[6.0]
  def change
    create_table :catalogue_variants do |t|
      t.references :catalogue, null: false, foreign_key: true
      t.references :catalogue_variant_color, null: true, foreign_key: true
      t.references :catalogue_variant_size, null: true, foreign_key: true
      t.decimal :price
      t.integer :stock_qty
      t.boolean :on_sale
      t.decimal :sale_price
      t.decimal :discount_price
      t.float :length
      t.float :breadth
      t.float :height

      t.timestamps
    end
  end
end
