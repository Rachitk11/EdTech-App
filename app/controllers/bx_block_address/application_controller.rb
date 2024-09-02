module BxBlockAddress
  class ApplicationController < BuilderBase::ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    private

    def not_found
      render json: {"errors" => ["Record not found"]}, status: :not_found
    end

    def get_account
      @account = AccountBlock::Account.find(@token.id)
    end

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << {attribute => error}
      end
      result
    end
  end
end
