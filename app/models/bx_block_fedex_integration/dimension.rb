# == Schema Information
#
# Table name: dimensions
#
#  id         :bigint           not null, primary key
#  item_id    :bigint           not null
#  height     :float
#  length     :float
#  width      :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module BxBlockFedexIntegration
  class Dimension < BxBlockFedexIntegration::ApplicationRecord
    self.table_name = :dimensions

    belongs_to :item, class_name: "BxBlockFedexIntegration::Item"
  end
end
