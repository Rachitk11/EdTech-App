# frozen_string_literal: true

# == Schema Information
#
# Table name: order_trackings
#
#  id          :bigint           not null, primary key
#  parent_type :string
#  parent_id   :bigint
#  tracking_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
module BxBlockOrderManagement
  class OrderTracking < BxBlockOrderManagement::ApplicationRecord
    self.table_name = :order_trackings
    include PublicActivity::Model
    tracked owner: proc { |controller, model| controller&.current_user }
    belongs_to :parent, polymorphic: true
    belongs_to :tracking

    scope :parent_orders, -> { where(parent_type: "Order") }
    scope :parent_order_items, -> { where(parent_type: "OrderItem") }
  end
end
