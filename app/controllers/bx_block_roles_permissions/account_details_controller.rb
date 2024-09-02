module BxBlockRolesPermissions
  class AccountDetailsController < ApplicationController
    # protect_from_forgery with: :exception
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token, only: [:list_users]

    def list_users
      @account = AccountBlock::Account.find(@token.id)
      @accounts = AccountBlock::Account.all
      if @account.present? && check_admin_auth
        render json: AccountBlock::AccountSerializer.new(@accounts).serializable_hash, status: :ok
      else
        render json: {errors: "account does not have access"}, status: :unauthorized
      end
    end

    def check_admin_auth
      @account.try(:role).try(:name) == "admin"
    end
  end
end
