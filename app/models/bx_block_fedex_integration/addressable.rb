# == Schema Information
#
# Table name: addressables
#
#  id           :bigint           not null, primary key
#  shipment_id  :bigint           not null
#  address      :text
#  address2     :text
#  city         :string
#  country      :string
#  email        :string
#  name         :string
#  phone        :string
#  instructions :text
#  type         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
module BxBlockFedexIntegration
  class Addressable < BxBlockFedexIntegration::ApplicationRecord
    self.table_name = :addressables

    belongs_to :shipment, class_name: "BxBlockFedexIntegration::Shipment"
    has_one :arrival_window,
            class_name: "BxBlockFedexIntegration::ArrivalWindow", dependent: :destroy
    has_one :coordinate,
            class_name: "BxBlockFedexIntegration::Coordinate", dependent: :destroy

    accepts_nested_attributes_for :arrival_window, :coordinate
  end
end
