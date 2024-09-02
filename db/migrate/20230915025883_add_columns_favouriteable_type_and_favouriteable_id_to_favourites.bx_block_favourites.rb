# This migration comes from bx_block_favourites (originally 20210205062438)
class AddColumnsFavouriteableTypeAndFavouriteableIdToFavourites < ActiveRecord::Migration[6.0]
  def change
    add_column :favourites, :favouriteable_id, :integer
    add_column :favourites, :favouriteable_type, :string
  end
end
