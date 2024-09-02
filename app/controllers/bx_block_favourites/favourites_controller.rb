module BxBlockFavourites
  class FavouritesController < ApplicationController
    def index
      favourites = BxBlockFavourites::Favourite.where(user_id: current_user.id)
      if params[:favouriteable_type]
        favourites = favourites.where(favouriteable_type: params[:favouriteable_type])
      end

      if favourites.present?
        serializer = BxBlockFavourites::FavouriteSerializer.new(favourites)
        render json: serializer.serializable_hash,
          status: :ok
      else
        render json: {
          errors: 'Favourites not found'
        }, status: :not_found
      end
    end

    def create
      favourite = BxBlockFavourites::Favourite.new(
        favourites_params.merge({user_id: current_user.id})
      )
      if favourite.save
        serializer = BxBlockFavourites::FavouriteSerializer.new(favourite)
        render json: serializer.serializable_hash,
          status: :ok
      else
        render json: {errors: favourite.errors},
          status: :unprocessable_entity
      end
    rescue => e
      render json: {errors: e.message},
        status: :unprocessable_entity
    end

    def destroy
      favourite =
        BxBlockFavourites::Favourite.find(params[:id])
      if favourite.destroy
        render json: {message: "Destroy successfully"},
          status: :ok
      end
    end

    private

    def favourites_params
      params.require(:data).permit \
        :favouriteable_id, :favouriteable_type
    end
  end
end
