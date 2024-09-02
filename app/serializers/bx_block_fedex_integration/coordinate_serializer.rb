# == Schema Information
#
# Table name: coordinates
#
#  id             :bigint           not null, primary key
#  latitude       :string
#  longitude      :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  addressable_id :integer
#
module BxBlockFedexIntegration
  class CoordinateSerializer < BuilderBase::BaseSerializer
    attributes *[
        :latitude,
        :longitude,
    ]
  end
end
