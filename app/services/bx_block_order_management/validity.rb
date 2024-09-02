# frozen_string_literal: true

module BxBlockOrderManagement
  class Validity
    attr_accessor :params, :coupon_code, :cart_value, :order, :user

    def initialize(params, user)
      @params = params
      @coupon_code = BxBlockCouponCg::CouponCode.find_by_code(params[:code])
      @order = BxBlockOrderManagement::Order.find(params[:cart_id])
      @cart_value = params[:cart_value].to_f
      @user = user
    end

    def check_cart_total
      if coupon_code.min_cart_value && cart_value < coupon_code.min_cart_value
        respond_error("min")
      elsif coupon_code.max_cart_value && cart_value > coupon_code.max_cart_value
        respond_error("max")
      else
        calculate_discount
      end
    end

    def calculate_discount
      discount = if coupon_code.discount_type == "percentage"
        ((cart_value * coupon_code.discount) / 100)
      else
        coupon_code.discount
      end
      discount_price = (cart_value - discount)&.round(2)
      if discount < cart_value
        order.update!(
          coupon_code_id: coupon_code.id, total: discount_price, applied_discount: discount
        )
        OpenStruct.new(
          success?: true,
          data: {
            coupon: coupon_code,
            price: cart_value,
            discount_type: coupon_code.discount_type,
            cart_discount: coupon_code.discount,
            discount_price: discount,
            after_discount_price: discount_price
          },
          msg: "Coupon applied successfully",
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

    def respond_error(value)
      if value == "min"
        min_cart_error
      else
        max_cart_error
      end
    end

    def min_cart_error
      if params[:existing_cart] == true
        remove_coupon
        OpenStruct.new(
          success?: false,
          data: nil,
          msg: "Your coupon has been removed due to min cart limit",
          code: 208
        )
      else
        OpenStruct.new(
          success?: false,
          data: nil,
          msg: "Please add few more product(s) to apply this coupon",
          code: 208
        )
      end
    end

    def max_cart_error
      if params[:existing_cart] == true
        remove_coupon
        OpenStruct.new(
          success?: false,
          data: nil,
          msg: "Your coupon has been removed due to max cart limit",
          code: 208
        )
      else
        OpenStruct.new(
          success?: false,
          data: nil,
          msg: "Your cart amount is exceeding the limit value. Please check coupon desctiption",
          code: 208
        )
      end
    end

    def remove_coupon
      order.update!(coupon_code_id: nil, applied_discount: 0)
      order.update!(total: order.total_price, sub_total: order.total_price)
    end
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize
