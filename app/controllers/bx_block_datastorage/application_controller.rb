module BxBlockDatastorage
  class ApplicationController < BuilderBase::ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token

    rescue_from ActiveRecord::RecordNotFound, :with => :not_found

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end
 
    private

    def not_found
      render :json => {'errors' => ['Record not found']}, :status => :not_found
    end

    def current_user
      @current_user ||= AccountBlock::Account.find(@token.id)
    rescue ActiveRecord::RecordNotFound
      render json: {
        errors: [{message: "Authentication token invalid"}]
      }, status: :unprocessable_entity
    end
  end
end
