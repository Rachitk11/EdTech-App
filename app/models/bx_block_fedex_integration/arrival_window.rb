# == Schema Information
#
# Table name: arrival_windows
#
#  id             :bigint           not null, primary key
#  begin_at       :datetime
#  end_at         :datetime
#  exclude_begin  :boolean          default(TRUE)
#  exclude_end    :boolean          default(TRUE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  addressable_id :integer
#
module BxBlockFedexIntegration
  class ArrivalWindow < BxBlockFedexIntegration::ApplicationRecord
    self.table_name = :arrival_windows

    END_AT_DAYS = 10.freeze

    belongs_to :addressable, class_name: "BxBlockFedexIntegration::Addressable"

    after_initialize :set_end_at

    private

    def set_end_at
      self.end_at ||= begin_at + END_AT_DAYS.days if begin_at.present?
    end
  end
end
