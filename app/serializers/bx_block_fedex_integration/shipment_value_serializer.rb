# == Schema Information
#
# Table name: shipment_values
#
#  id          :bigint           not null, primary key
#  shipment_id :bigint           not null
#  amount      :float
#  currency    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
module BxBlockFedexIntegration
  class ShipmentValueSerializer < BuilderBase::BaseSerializer
    attributes *[
        :amount,
        :currency,
    ]
  end
end
