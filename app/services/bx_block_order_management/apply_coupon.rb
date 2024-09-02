# frozen_string_literal: true

module BxBlockOrderManagement
  class ApplyCoupon
    attr_accessor :coupon_code, :cart_value, :order

    def initialize(order, coupon, params)
      @coupon_code = coupon
      @order = order
      @cart_value = params[:cart_value].to_f
    end

    def call
      discount = if coupon_code.discount_type == "percentage"
        ((cart_value * coupon_code.discount) / 100)
      else
        coupon_code.discount
      end
      if discount < cart_value
        discount_price = (cart_value - discount)&.round(2)
        order.update(coupon_code_id: coupon_code.id, total: discount_price, applied_discount: discount)
        OpenStruct.new(
          success?: false,
          msg: "Coupon applied to all items in the order with status in cart",
          code: 200
        )
      else
        discount_price = (discount - cart_value)&.round(2)
        order.update(coupon_code_id: coupon_code.id, total: 0, applied_discount: discount)
        coupon_code.update(discount:discount_price)
        OpenStruct.new(
          success?: false,
          msg: "Coupon has still left discount of #{discount_price}",
          code: 200
        )
      end
    end
  end
end
