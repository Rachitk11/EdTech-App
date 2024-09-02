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
  class ItemSerializer < BuilderBase::BaseSerializer
    attributes *[
        :ref_id,
        :weight,
        :quantity,
        :stackable,
        :type,
        :dimensions,
    ]

    attribute :type do |object|
      object.item_type
    end

    attribute :dimensions do |object|
      DimensionSerializer
          .new(object.dimension)
          .serializable_hash[:data][:attributes]
    end
  end
end
