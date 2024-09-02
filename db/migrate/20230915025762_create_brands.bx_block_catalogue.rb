# This migration comes from bx_block_catalogue (originally 20201007144101)
class CreateBrands < ActiveRecord::Migration[6.0]
  def change
    create_table :brands do |t|
      t.string :name

      t.timestamps
    end
  end
end
