# frozen_string_literal: true

module BxBlockOrderManagement
  class UpdateCartValue
    attr_accessor :order

    def initialize(order, user)
      @order = order
      @user = user
    end

    def call
      save_order
      BxBlockOrderManagement::Validity.new(order_attributes, @user).check_cart_total if order.coupon_code.present?
    end

    def save_order
      update_order_total
      update_order_sub_total
      order.save
    end

    private

    def order_attributes
      {
        code: order.coupon_code.code,
        cart_id: order.id,
        cart_value: order.sub_total,
        existing_cart: true
      }
    end

    def update_order_total
      order.total = order.total_price
      order.total_after_shipping_charge
      order.total_after_tax_charge
    end

    def update_order_sub_total
      order.sub_total = order.sub_total_price
    end
  end
end
