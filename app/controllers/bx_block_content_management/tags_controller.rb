module BxBlockContentManagement
  class TagsController < ApplicationController
    skip_before_action :validate_json_web_token, only: [:index]

    def index
      tags = ActsAsTaggableOn::Tag.all.page(params[:page]).per(params[:per_page])
      render json: TagSerializer.new(tags).serializable_hash, status: :ok
    end
  end
end
