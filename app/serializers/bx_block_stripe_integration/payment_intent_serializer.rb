module BxBlockStripeIntegration
  class PaymentIntentSerializer
    include FastJsonapi::ObjectSerializer

    attributes(:id, :amount, :amount_capturable, :amount_details, :amount_received, :charges, :client_secret, :confirmation_method, :created, :currency, :customer, :payment_method, :payment_method_types)
  end
end
