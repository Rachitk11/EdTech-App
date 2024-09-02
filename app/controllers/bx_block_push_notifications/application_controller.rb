module BxBlockPushNotifications
  class ApplicationController < BuilderBase::ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token

    rescue_from ActiveRecord::RecordNotFound, :with => :not_found

    private

    def not_found
      render :json => {'errors' => ['Record not found']}, :status => :not_found
    end

    def current_user
      @current_user ||= AccountBlock::Account.find(@token.id) if @token.present?
    end

  end
end
