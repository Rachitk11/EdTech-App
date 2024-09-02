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
  class Delivery < Addressable
  end
end
