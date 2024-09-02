module BxBlockStripeIntegration
  class CreatePaymentMethod
    def initialize(card_details)
      @card_details = card_details
    end

    def call
      if @card_details[:cvc].nil? || @card_details[:cvc].to_s.length != 3
        return [false, "cvc is invalid"]
      end

      [true, Stripe::PaymentMethod.create(
        {type: "card", card: @card_details.symbolize_keys}
      )]
    rescue Stripe::StripeError => e
      [false, e.message]
    end
  end
end
