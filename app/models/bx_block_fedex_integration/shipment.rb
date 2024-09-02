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
  class Shipment < BxBlockFedexIntegration::ApplicationRecord
    self.table_name = :shipments

    belongs_to :create_shipment, class_name: "BxBlockFedexIntegration::CreateShipment"
    has_one :cod_value, dependent: :destroy,
            class_name: "BxBlockFedexIntegration::CodValue"
    has_one :shipment_value,
            class_name: "BxBlockFedexIntegration::ShipmentValue", dependent: :destroy
    has_one :delivery,
            class_name: "BxBlockFedexIntegration::Delivery", dependent: :destroy
    has_one :pickup,
            class_name: "BxBlockFedexIntegration::Pickup", dependent: :destroy
    has_many :items, class_name: "BxBlockFedexIntegration::Item", dependent: :destroy

    accepts_nested_attributes_for :cod_value, :shipment_value, :delivery, :pickup, :items

    after_initialize :set_ref_id

    private

    def set_ref_id
      self.ref_id = loop do
        random_id = "shipment-#{SecureRandom.hex(10)}"
        break random_id unless Shipment.exists?(ref_id: random_id)
      end
    end
  end
end
