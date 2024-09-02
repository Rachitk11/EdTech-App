# frozen_string_literal: true

module BxBlockProfileBio
  # rubocop:disable Style/GuardClause
  # app/controller/ApplicationCOntroller
  class ApplicationController < BuilderBase::ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    private

    def not_found
      render json: { 'errors' => ['Record not found'] }, status: :not_found
    end

    def current_user
      @current_user ||= AccountBlock::Account.find(@token.id) if @token.present?
    end

    def check_account_activated
      account = AccountBlock::Account.find_by(id: current_user.id)
      unless account.activated
        render json: { error: {
          message: 'Account has been not activated'
        } }, status: :unprocessable_entity
      end
    end
  end
  # rubocop:enable Style/GuardClause
end
