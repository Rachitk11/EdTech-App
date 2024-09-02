# == Schema Information
#
# Table name: create_shipments
#
#  id                  :bigint           not null, primary key
#  auto_assign_drivers :boolean          default(FALSE)
#  requested_by        :string
#  shipper_id          :string
#  waybill             :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
module BxBlockFedexIntegration
  class CreateShipmentSerializer < BuilderBase::BaseSerializer
    attributes *[
        :auto_assign_drivers,
        :requested_by,
        :shipper_id,
        :shipments,
    ]

    attribute :shipments do |object|
      ShipmentSerializer
          .new(object.shipments)
          .serializable_hash[:data]
          .map { |data| data[:attributes] }
    end
  end
end
