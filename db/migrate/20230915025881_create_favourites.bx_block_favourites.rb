# This migration comes from bx_block_favourites (originally 20210102105020)
class CreateFavourites < ActiveRecord::Migration[6.0]
  def change
    create_table :favourites do |t|
      t.integer :profile_bio_id
      t.integer :favourite_by_id
      t.integer :status, default: 1

      t.timestamps
    end
  end
end
