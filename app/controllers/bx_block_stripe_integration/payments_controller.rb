module BxBlockStripeIntegration
  class PaymentsController < BxBlockStripeIntegration::ApplicationController
    before_action :check_create_stripe_customer, :find_currency, only: [:create]

    def create
      return unless validate_parameters(payment_params, %w[payment_method_id])

      order = BxBlockOrderManagement::Order.find_by_id(payment_params[:order_id])

      if order.present?
        amount = (order.total.to_f * 100).to_i

        begin
          stripe_payment_intent = Stripe::PaymentIntent.create(
            customer: current_user.stripe_id,
            amount: amount,
            currency: @brand.currency,
            payment_method: payment_params[:payment_method_id]
          )
          render json: PaymentIntentSerializer.new(PaymentIntent.new(stripe_payment_intent)).serializable_hash
        rescue Stripe::StripeError => e
          render json: {errors: [{stripe: e.message}]}, status: :unprocessable_entity
        end
      else
        render json: {errors: [order: "Order Not Found."]}, status: :not_found
      end
    end

    def confirm
      return unless validate_parameters(payment_params, %w[payment_method_id payment_intent_id])

      unless current_user.stripe_id.present?
        render json: {
          error: "Customer stripe id is not found"
        }, status: :not_found and return
      end

      begin
        stripe_payment_intent = Stripe::PaymentIntent.confirm(
          payment_params[:payment_intent_id],
          {
            payment_method: payment_params[:payment_method_id],
            receipt_email: current_user.email
          }
        )
        render json: PaymentIntentSerializer.new(PaymentIntent.new(stripe_payment_intent)).serializable_hash
      rescue Stripe::StripeError => e
        render json: {
          errors: [{stripe: e.message}]
        }, status: :unprocessable_entity
      end
    end

    private

    def payment_params
      params.require(:payment).permit(:order_id, :payment_method_id, :payment_intent_id)
    end

    def find_currency
      @brand = BxBlockCatalogue::Brand.last
      unless @brand.present? && @brand.currency.present?
        render json: {
          error: "Brand with a currency is not set"
        }, status: :not_found
      end
    end
  end
end
