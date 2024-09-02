# == Schema Information
#
# Table name: shipments
#
#  id                 :bigint           not null, primary key
#  create_shipment_id :bigint           not null
#  ref_id             :string
#  full_truck         :boolean          default(FALSE)
#  load_description   :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
module BxBlockFedexIntegration
  class ShipmentSerializer < BuilderBase::BaseSerializer
    attributes *[
        :ref_id,
        :full_truck,
        :load_description,
        :cod_value,
        :shipment_value,
        :delivery,
        :pickup,
        :items,
    ]

    attribute :cod_value do |object|
      CodValueSerializer
          .new(object.cod_value)
          .serializable_hash[:data][:attributes]
    end

    attribute :shipment_value do |object|
      ShipmentValueSerializer
          .new(object.shipment_value)
          .serializable_hash[:data][:attributes]
    end

    attribute :delivery do |object|
      DeliverySerializer
          .new(object.delivery)
          .serializable_hash[:data][:attributes]
    end

    attribute :pickup do |object|
      PickupSerializer
          .new(object.pickup)
          .serializable_hash[:data][:attributes]
    end

    attribute :items do |object|
      ItemSerializer
          .new(object.items)
          .serializable_hash[:data]
          .map { |data| data[:attributes] }
    end
  end
end
