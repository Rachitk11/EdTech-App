module BxBlockContentManagement
  class FollowsController < ApplicationController
    before_action :validate_json_web_token, only: [:create, :destroy, :index, :followers_content]

    def create
      follow = current_user.followers.new(content_provider_id: params[:content_provider_id])

      if follow.save
        render json: FollowSerializer.new(follow).serializable_hash,
             status: :created
      else
        render json: ErrorSerializer.new(follow).serializable_hash,
             status: :unprocessable_entity
      end
    end

    def index
      render json: BxBlockContentManagement::ContentProviderSerializer.new(
        current_user.content_provider_followings, serialization_options
      ).serializable_hash, status: :ok
    end

    def destroy
      follow = current_user.followers.find(params[:id])
      if follow.destroy
        render json: { success: true }, status: :ok
      else
        render json: ErrorSerializer.new(follow).serializable_hash,
               status: :unprocessable_entity
      end
    end

    private
    def serialization_options
      options = {}
      options[:params] = { current_user_id: current_user&.id}
      options
    end
  end
end
