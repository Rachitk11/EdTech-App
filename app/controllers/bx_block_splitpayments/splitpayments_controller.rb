module BxBlockSplitpayments
  class SplitpaymentsController < BxBlockSplitpayments::ApplicationController
    def split_payment
      @order = BxBlockShoppingCart::Order.find_by(id: params[:order_id])
      if !@order.present?
        return render json: {errors: "Order Not Found"}, status: :unprocessable_entity
      end
      if @order.is_split == true
        return render json: {order_detail: @order}, status: :ok
      else
        BxBlockSplitpayments::Order.complete_order(@order)
        @order = BxBlockShoppingCart::Order.find_by(id: @order.id)
        return render json: {order_detail: @order}, status: :ok
      end
    end
  end
end