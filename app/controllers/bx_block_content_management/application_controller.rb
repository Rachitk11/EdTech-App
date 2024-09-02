module BxBlockContentManagement
  class ApplicationController < BuilderBase::ApplicationController
    include JSONAPI::Deserialization
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token

    rescue_from ActiveRecord::RecordNotFound, :with => :not_found

    around_action :set_locale

    before_action :update_current_user

    private

    def not_found
      render :json => {'errors' => [app_t('controllers.application.errors.record_not_found')]}, :status => :not_found
    end

    def assign_json_web_token
      token = request.headers[:token] || params[:token]
      begin
        @token = BuilderJsonWebToken::JsonWebToken.decode(token)
      rescue *ERROR_CLASSES => exception
      end
    end

    def current_user
      return unless @token
      account_id = @token.id
      account = AccountBlock::Account.find(account_id)
    end

    def set_locale
      lang = params[:language] || I18n.default_locale
      Globalize.with_locale(lang) do
        yield
      end
    end

    def format_activerecord_errors(errors)
      [{ error: errors.full_messages.first }]
    end

    def app_t(key)
      BxBlockLanguageOptions::ApplicationMessage.translation_message(key)
    end

    def update_current_user
      current_user.update(last_visit_at: Time.now) if current_user.present?
    end
  end
end
