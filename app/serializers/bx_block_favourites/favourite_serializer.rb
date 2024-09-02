module BxBlockFavourites
  class FavouriteSerializer < BuilderBase::BaseSerializer
    attributes(:favouriteable_id, :favouriteable_type, :user_id, :created_at, :updated_at)
  end
end
