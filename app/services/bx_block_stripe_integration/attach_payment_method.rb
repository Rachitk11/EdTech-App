module BxBlockStripeIntegration
  class AttachPaymentMethod
    def initialize(customer_stripe_id, payment_method_id)
      @customer_stripe_id = customer_stripe_id
      @payment_method_id = payment_method_id
    end

    def call
      [true, Stripe::PaymentMethod.attach(
        @payment_method_id,
        {customer: @customer_stripe_id}
      )]
    rescue Stripe::StripeError => e
      [false, e.message]
    end
  end
end
