module BxBlockStripeIntegration
  class PaymentMethodsController < BxBlockStripeIntegration::ApplicationController
    before_action :check_create_stripe_customer, only: [:index, :create]

    def index
      stripe_payment_methods = Stripe::PaymentMethod.list(customer: current_user.stripe_id, type: "card")
      payment_methods = []
      stripe_payment_methods.each do |stripe_pm|
        payment_methods << PaymentMethod.new(stripe_pm)
      end
      render json: PaymentMethodSerializer.new(payment_methods).serializable_hash
    rescue Stripe::StripeError => e
      render json: {
        errors: [{stripe: e.message}]
      }, status: :unprocessable_entity
    end

    def create
      valid, result = CreatePaymentMethod.new(payment_method_params.to_h).call

      if valid
        valid, result = AttachPaymentMethod.new(current_user.stripe_id, result.id).call
        if valid
          render json: PaymentMethodSerializer.new(PaymentMethod.new(result)).serializable_hash
        else
          render json: {
            errors: [{stripe: result}]
          }, status: :unprocessable_entity
        end
      else
        render json: {
          errors: [{stripe: result}]
        }, status: :unprocessable_entity
      end
    end

    private

    def check_create_stripe_customer
      return if current_user.stripe_id.present?

      stripe_customer = Stripe::Customer.create({email: current_user.email})
      current_user.update(stripe_id: stripe_customer.id)
    end

    def payment_method_params
      params.require(:payment_method).permit(:number, :exp_month, :exp_year, :cvc)
    end
  end
end
