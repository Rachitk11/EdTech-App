module BxBlockShoppingCart
  class OrderItem < ApplicationRecord
    self.table_name = :shopping_cart_order_items
    belongs_to :order, class_name: "BxBlockShoppingCart::Order", foreign_key: :order_id
    belongs_to :catalogue, class_name: "BxBlockCatalogue::Catalogue", foreign_key: :catalogue_id

    before_save :assign_price_to_order_item
    after_save :update_order_total
    after_destroy :update_order_total

    validate :order_can_be_updated

    def order_can_be_updated
      if ["cancelled", "completed"].include?(order.status)
        errors.add(:order, "has already been #{order.status}")
      end
    end

    def assign_price_to_order_item
      self.price = catalogue.sale_price.to_f
    end

    def update_order_total
      order.update(
        total_fees: calculate_total_fees,
        total_items: count_total_items,
        total_tax: calculate_total_tax
      )
    end

    def calculate_total_fees
      order.order_items.map { |item| item.price * item.quantity }.sum
    end

    def count_total_items
      order.order_items.map { |item| item.quantity }.sum
    end

    def calculate_total_tax
      order.order_items.map { |item| item.quantity * item.taxable_value }.reject(&:blank?).sum
    end
  end
end
