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
  class DeliverySerializer < BuilderBase::BaseSerializer
    attributes *[
        :address,
        :address2,
        :city,
        :country,
        :email,
        :name,
        :phone,
        :instructions,
        :arrival_window,
        :coordinate,
    ]

    attribute :arrival_window do |object|
      ArrivalWindowSerializer
          .new(object.arrival_window)
          .serializable_hash[:data][:attributes]
    end

    attribute :coordinate do |object|
      CoordinateSerializer
          .new(object.coordinate)
          .serializable_hash[:data][:attributes]
    end
  end
end
