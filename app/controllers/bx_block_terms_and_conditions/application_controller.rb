module BxBlockTermsAndConditions
  class ApplicationController < BuilderBase::ApplicationController
    # include ActionController::RequestForgeryProtection
    include BuilderJsonWebToken::JsonWebTokenValidation
    # protect_from_forgery with: :null_session

    # before_action :validate_json_web_token

    # rescue_from ActiveRecord::RecordNotFound, with: :not_found

    def current_user
      @current_user = AccountBlock::Account.find(@token.id)
    rescue ActiveRecord::RecordNotFound
      render json: {errors: [
        {message: "Please login again."}
      ]}, status: :unprocessable_entity
    end

    # def admin_auth
    #   current_user.role.present? && current_user.role.name.eql?("group_admin") ? "true" : "false"
    # end

    # def basic_auth
    #   current_user.role.present? && current_user.role.name.eql?("group_basic") ? "true" : "false"
    # end

    # def account_auth
    #   current_user.id.eql?(params[:account_id].to_i) ? "true" : "false"
    # end

    private

    def not_found
      render json: {"errors" => ["Record not found"]}, status: :not_found
    end
  end
end
