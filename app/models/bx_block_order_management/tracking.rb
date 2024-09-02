# frozen_string_literal: true

# == Schema Information
#
# Table name: trackings
#
#  id              :bigint           not null, primary key
#  status          :string
#  tracking_number :string
#  date            :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
module BxBlockOrderManagement
  class Tracking < BxBlockOrderManagement::ApplicationRecord
    self.table_name = :trackings
    include PublicActivity::Model
    tracked owner: proc { |controller, model| controller&.current_user }
    has_many :order_trackings, dependent: :destroy

    has_many :orders, through: :order_trackings, source: :parent, source_type: "Order"
    has_many :order_items, through: :order_trackings, source: :parent, source_type: "OrderItem"

    TRACKING_NO_FORMAT = "00000000"

    before_create :add_tracking_number

    def add_tracking_number
      self.tracking_number = "TR#{Tracking.next_tracking_number}"
    end

    def self.next_tracking_number
      return Tracking::TRACKING_NO_FORMAT.succ if Tracking.count.zero?

      Tracking.last.tracking_number.split("TR")[1].succ
    end
  end
end
