module BxBlockStripeIntegration
  class PaymentIntent
    attr_reader :id, :amount, :amount_capturable, :amount_details, :amount_received, :charges,
      :client_secret, :confirmation_method, :created, :currency, :customer, :payment_method,
      :payment_method_types

    def initialize(stripe_payment_intent)
      @id = stripe_payment_intent[:id]
      @amount = stripe_payment_intent[:amount]
      @amount_capturable = stripe_payment_intent[:amount_capturable]
      @amount_details = stripe_payment_intent[:amount_details]
      @amount_received = stripe_payment_intent[:amount_received]
      @charges = stripe_payment_intent[:charges]
      @client_secret = stripe_payment_intent[:client_secret]
      @confirmation_method = stripe_payment_intent[:confirmation_method]
      @created = stripe_payment_intent[:created]
      @currency = stripe_payment_intent[:currency]
      @customer = stripe_payment_intent[:customer]
      @payment_method = stripe_payment_intent[:payment_method]
      @payment_method_types = stripe_payment_intent[:payment_method_types]
    end
  end
end
