# frozen_string_literal: true

module BxBlockBulkUploading
  class ApplicationController < BuilderBase::ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    # def current_user
    #   @current_user = AccountBlock::Account.find(@token.id)
    # rescue ActiveRecord::RecordNotFound => e
    #   render json: {errors: [
    #     {message: "Please login again."}
    #   ]}, status: :unprocessable_entity
    # end

    private

    def not_found
      render json: {"errors" => ["Record not found"]}, status: :not_found
    end
  end
end
