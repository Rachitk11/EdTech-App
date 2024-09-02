module BxBlockOrderManagement
  class MyOrderSerializer < BuilderBase::BaseSerializer
    attributes(
      :id,
      :order_number,
      :amount,
      :status,
      :account_id, 
      :total_tax, 
      :created_at, 
      :updated_at, 
      :order_status_id, 
      :tax_charges, 
      :confirmed_at, 
      :cancelled_at,  
      :placed_at, 
      :order_date, 
      :total
    )

    attribute :order_items do |object, params|
      if object.present?
        OrderItemSerializer.new(
          object.order_items, {params: params}
        ).serializable_hash[:data]
      end
    end
  end
end