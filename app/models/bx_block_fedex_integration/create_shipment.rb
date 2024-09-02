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
  class CreateShipment < BxBlockFedexIntegration::ApplicationRecord
    self.table_name = :create_shipments

    has_many :shipments, class_name: "BxBlockFedexIntegration::Shipment", dependent: :destroy

    accepts_nested_attributes_for :shipments

    after_initialize :set_default_values

    private

    def set_default_values
      self.requested_by = ["development","test"].include?(Rails.env) ?
           'Profile_67ff1b39-37f0-4f6c-aac7-71cf844b331a' : ENV['_525K_PROFILE_ID']
      self.shipper_id = ["development","test"].include?(Rails.env) ?
           'Profile_67ff1b39-37f0-4f6c-aac7-71cf844b331a' : ENV['_525K_PROFILE_ID']
    end
  end
end
