# frozen_string_literal: true

module BxBlockOrderManagement
  class ApplicationController < BuilderBase::ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token
    before_action :current_user
    include PublicActivity::StoreController

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    def current_user
      @current_user = AccountBlock::Account.find(@token.id)
    end

    private

    def not_found
      render json: {"errors" => ["Record not found"]}, status: :not_found
    end
  end
end
# rubocop:enable Naming/AccessorMethodName
