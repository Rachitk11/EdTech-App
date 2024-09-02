# This migration comes from bx_block_catalogue (originally 20201008085059)
class CreateCatalogueTags < ActiveRecord::Migration[6.0]
  def change
    create_table :catalogue_tags do |t|
      t.string :name

      t.timestamps
    end
  end
end
