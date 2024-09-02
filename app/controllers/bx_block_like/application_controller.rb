module BxBlockLike
  class ApplicationController < BuilderBase::ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token
    before_action :check_account_activated

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    private

    def not_found
      render json: {
        "errors" => [
          "Record not found"
        ]
      }, status: :not_found
    end

    def current_user
      return if @token.blank?
      @current_user ||= AccountBlock::Account.find(@token.id)
    end

    def check_account_activated
      account = AccountBlock::Account.find_by(id: current_user.id)
      unless account.activated
        render json: {error: {
          message: "Account has been not activated"
        }}, status: :unprocessable_entity
      end
    end
  end
end
