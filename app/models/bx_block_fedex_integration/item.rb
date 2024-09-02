# == Schema Information
#
# Table name: items
#
#  id          :bigint           not null, primary key
#  shipment_id :bigint           not null
#  ref_id      :string
#  weight      :float
#  quantity    :integer
#  stackable   :boolean          default(TRUE)
#  item_type   :integer          default("PALLET")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
module BxBlockFedexIntegration
  class Item < BxBlockFedexIntegration::ApplicationRecord
    self.table_name = :items

    belongs_to :shipment, class_name: "BxBlockFedexIntegration:Shipment"
    has_one :dimension, class_name: "BxBlockFedexIntegration::Dimension", dependent: :destroy

    enum item_type: %w(PALLET BOX OTHER)

    accepts_nested_attributes_for :dimension

    after_initialize :set_ref_id

    private

    def set_ref_id
      self.ref_id = loop do
        random_id = "item-#{SecureRandom.hex(10)}"
        break random_id unless Item.exists?(ref_id: random_id)
      end
    end
  end
end
