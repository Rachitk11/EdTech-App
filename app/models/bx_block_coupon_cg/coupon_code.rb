module BxBlockCouponCg
  class CouponCode < BxBlockCouponCg::ApplicationRecord
    self.table_name = :coupon_codes

    DISCOUNT_TYPE = {
        flat: 'flat',
        percentage: 'percentage'
    }.freeze

    MAX_CART_VALUE = 100_000
    MAX_DISCOUNT_VALUE = 100_000

    validates :title, length: { maximum: 50 }, presence: true
    validates :description, length: { maximum: 200 }
    validates :code, length: { maximum: 50 }, presence: true
    validates :code, uniqueness: true

    validates :discount_type, acceptance: {
        accept: [DISCOUNT_TYPE[:flat], DISCOUNT_TYPE[:percentage]]
    }
    validate :min_cart_value_not_negative
    validate :max_cart_value_less_max_value
    validate :discount_value

    def min_cart_value_not_negative
      if min_cart_value.negative?
        errors.add(:min_cart_value, "Can't be less than zero")
      end
    end

    def max_cart_value_less_max_value
      if max_cart_value > MAX_CART_VALUE
        errors.add(:max_cart_value, "Can't be more than #{MAX_CART_VALUE}")
      end
    end

    def discount_value
      if discount.negative? || discount > MAX_DISCOUNT_VALUE
        errors.add(:discount, 'Discount value is out of bounds')
      end
    end
  end
end
