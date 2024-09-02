module BxBlockStripeIntegration
  class PaymentMethodSerializer
    include FastJsonapi::ObjectSerializer

    attributes(:billing_details, :card, :customer, :created)
  end
end
