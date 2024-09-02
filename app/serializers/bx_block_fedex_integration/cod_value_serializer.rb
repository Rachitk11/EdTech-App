# == Schema Information
#
# Table name: cod_values
#
#  id          :bigint           not null, primary key
#  shipment_id :bigint           not null
#  amount      :float
#  currency    :string           default("RS")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
module BxBlockFedexIntegration
  class CodValueSerializer < BuilderBase::BaseSerializer
    attributes *[
        :amount,
        :currency,
    ]
  end
end
