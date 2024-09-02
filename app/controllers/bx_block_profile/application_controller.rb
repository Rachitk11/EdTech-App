module BxBlockProfile
  class ApplicationController < BuilderBase::ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token
    # serialization_scope :view_context

    private

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end
  end
end
