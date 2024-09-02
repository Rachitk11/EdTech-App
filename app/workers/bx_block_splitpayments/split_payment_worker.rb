module BxBlockSplitpayments
  class SplitPaymentWorker
	  include Sidekiq::Worker
	  def perform(*args)
	    @orders = BxBlockShoppingCart::Order.where(status: "completed", payment_mode: "online", is_split: false)
	    @orders.each do |order|
	      BxBlockSplitpayments::Order.complete_order(order)
	    end
	  end
	end
end