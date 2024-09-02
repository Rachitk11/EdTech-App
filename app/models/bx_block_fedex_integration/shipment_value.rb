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
  class ShipmentValue < BxBlockFedexIntegration::ApplicationRecord
    self.table_name = :shipment_values

    belongs_to :shipment, class_name: "BxBlockFedexIntegration::Shipment"
  end
end
