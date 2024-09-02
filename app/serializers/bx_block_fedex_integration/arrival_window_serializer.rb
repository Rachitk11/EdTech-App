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
  class ArrivalWindowSerializer < BuilderBase::BaseSerializer
    attributes *[
        :exclude_begin,
        :exclude_end,
        :begin,
        :end,
    ]

    attribute :begin do |object|
      object.begin_at
    end

    attribute :end do |object|
      object.end_at
    end
  end
end
