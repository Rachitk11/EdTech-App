module BxBlockStripeIntegration
  class ApplicationController < BuilderBase::ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token

    def current_user
      AccountBlock::Account.find(@token.id)
    end

    private

    def not_found
      render json: {"errors" => ["Record not found"]}, status: :not_found
    end

    def check_create_stripe_customer
      return if current_user.stripe_id.present?

      stripe_customer = Stripe::Customer.create({email: current_user.email})
      current_user.update(stripe_id: stripe_customer.id)
    end

    def validate_parameters(params_to_check, parameter_names)
      parameter_names.each do |parameter_name|
        unless params_to_check[parameter_name].present?
          render json: {
            errors: [params: "#{parameter_name} is not provided"]
          }, status: :unprocessable_entity and return false
        end
      end
    end
  end
end
