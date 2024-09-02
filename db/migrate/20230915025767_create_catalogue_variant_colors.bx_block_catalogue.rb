# This migration comes from bx_block_catalogue (originally 20201010075407)
class CreateCatalogueVariantColors < ActiveRecord::Migration[6.0]
  def change
    create_table :catalogue_variant_colors do |t|
      t.string :name

      t.timestamps
    end
  end
end
