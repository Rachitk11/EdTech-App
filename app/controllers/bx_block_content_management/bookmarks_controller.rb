module BxBlockContentManagement
  class BookmarksController < ApplicationController
    before_action :validate_json_web_token, only: [:create, :destroy, :index]

    def create
      bookmark = current_user.bookmarks.new(content_id: params[:content_id])

      if bookmark.save
        render json: BxBlockContentManagement::BookmarkSerializer.new(bookmark).serializable_hash,
             status: :created
      else
        render json: BxBlockContentManagement::ErrorSerializer.new(bookmark).serializable_hash,
             status: :unprocessable_entity
      end
    end

    def index
      contents = current_user.content_followings
      render json: BxBlockContentManagement::ContentSerializer.new(contents, serialization_options).serializable_hash,
             status: :ok
    end

    def destroy
      follow = current_user.bookmarks.find(params[:id])
      if follow.destroy
        render json: { success: true }, status: :ok
      else
        render json: BxBlockContentManagement::ErrorSerializer.new(follow).serializable_hash,
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
