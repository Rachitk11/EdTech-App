module BxBlockShoppingCart
  class OrderSerializer < BuilderBase::BaseSerializer
    attributes(:status, :total_fees, :total_items, :total_tax)

    attribute :customer do |object|
      AccountBlock::AccountSerializer.new(object.customer)
    end

    attribute :address do |object|
      BxBlockAddress::AddressSerializer.new(object.address)
    end

    attribute :order_items do |object|
      BxBlockShoppingCart::OrderItemSerializer.new(object.order_items)
    end

    class << self
      def order_services_for order
        order.sub_categories.pluck(:name)
        # order.services.map{|service| service.sub_category.name }
      end
    end
  end
end
