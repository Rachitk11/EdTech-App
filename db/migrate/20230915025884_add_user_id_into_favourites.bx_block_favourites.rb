# This migration comes from bx_block_favourites (originally 20220113120510)
class AddUserIdIntoFavourites < ActiveRecord::Migration[6.0]
  def change
    remove_column :favourites, :favourite_by_id, :integer
    add_column :favourites, :user_id, :integer
  end
end
