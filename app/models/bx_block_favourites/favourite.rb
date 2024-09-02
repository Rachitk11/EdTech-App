module BxBlockFavourites
  class Favourite < BxBlockFavourites::ApplicationRecord
    self.table_name = :favourites

    belongs_to :favouriteable, polymorphic: true
  end
end
