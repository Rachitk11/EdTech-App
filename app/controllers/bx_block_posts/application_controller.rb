module BxBlockPosts
  class ApplicationController < BuilderBase::ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    include PublicActivity::StoreController
    before_action :validate_json_web_token

    rescue_from ActiveRecord::RecordNotFound, :with => :not_found

    def current_user
      @current_user ||= AccountBlock::Account.find(@token.id) if @token.present?
    end

    private

    def not_found
      render :json => {'errors' => ['Record not found']}, :status => :not_found
    end


    def check_account_activated
      account = AccountBlock::Account.find_by(id: current_user.id)
      unless account.activated
        render json: { error: {
            message: "Account has been not activated"}
        }, status: :unprocessable_entity
      end
    end
  end
end
