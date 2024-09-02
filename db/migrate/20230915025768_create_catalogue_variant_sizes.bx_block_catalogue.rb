# This migration comes from bx_block_catalogue (originally 20201010075415)
class CreateCatalogueVariantSizes < ActiveRecord::Migration[6.0]
  def change
    create_table :catalogue_variant_sizes do |t|
      t.string :name

      t.timestamps
    end
  end
end
