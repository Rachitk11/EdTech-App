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
  class CodValue < BxBlockFedexIntegration::ApplicationRecord
    self.table_name = :cod_values

    belongs_to :shipment, class_name: "BxBlockFedexIntegration::Shipment"
  end
end
