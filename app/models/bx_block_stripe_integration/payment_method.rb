module BxBlockStripeIntegration
  class PaymentMethod
    attr_reader :id, :billing_details, :card, :customer, :created

    def initialize(stripe_payment_method)
      @id = stripe_payment_method[:id]
      @billing_details = stripe_payment_method[:billing_details]
      @card = stripe_payment_method[:card]
      @customer = stripe_payment_method[:customer]
      @created = stripe_payment_method[:created]
    end
  end
end
