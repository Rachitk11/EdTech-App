module BxBlockLike
  class LikesController < ApplicationController
    def index
      likes = if likeable_type
        BxBlockLike::Like.where(
          like_by_id: current_user.id,
          likeable_type: likeable_type
        )
      else
        BxBlockLike::Like.where(like_by_id: current_user.id)
      end

      if likes.present?
        render json: BxBlockLike::LikeSerializer.new(likes).serializable_hash,
          status: :ok
      else
        render json: {data: []}, status: :ok
      end
    end

    def create
      like = BxBlockLike::Like.find_or_initialize_by(
        like_params.merge({like_by_id: current_user.id})
      )
      like.save
      handle_create_response(like)
    rescue => like
      render json: {errors: [{like: like.message}]},
        status: :unprocessable_entity
    end

    def destroy
      like = BxBlockLike::Like.find_by(
        id: params[:id], like_by_id: current_user.id
      )

      if like.present?
        like.destroy
        render json: {message: "Successfully destroy"},
          status: :ok
      else
        render json: {message: "Not found"},
          status: :not_found
      end
    end

    private

    def like_params
      params.require(:data)[:attributes].permit \
        :likeable_id, :likeable_type
    end

    def likeable_type
      return if params[:like_type].blank?
      (params[:like_type] == "profile") ?
      ["BxBlockProfile::Profile", "BxBlockProfile::CareerExperience",
        "BxBlockProfile::Award", "BxBlockProfile::TestScoreAndCourse",
        "BxBlockProfile::Course", "BxBlockProfile::EducationalQualification",
        "BxBlockProfile::Project", "BxBlockComments::comment"] : "BxBlockPosts::Post"
    end

    def handle_create_response(like)
      if like.persisted?
        render json: BxBlockLike::LikeSerializer.new(like).serializable_hash,
          status: :ok
      else
        render json: {errors: [{like: like.errors.full_messages}]},
          status: :unprocessable_entity
      end
    end
  end
end
