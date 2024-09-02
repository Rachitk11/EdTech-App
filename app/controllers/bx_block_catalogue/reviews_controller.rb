module BxBlockCatalogue
  class ReviewsController < ApplicationController
    def create
      review = Review.new(
        catalogue_id: params[:catalogue_id],
        rating: params[:rating],
        comment: params[:comment]
      )
      save_result = review.save

      if save_result
        render json: ReviewSerializer.new(review).serializable_hash,
          status: :created
      else
        render json: ErrorSerializer.new(review).serializable_hash,
          status: :unprocessable_entity
      end
    end

    def index
      serializer = ReviewSerializer.new(Review.all)

      render json: serializer, status: :ok
    end
  end
end
