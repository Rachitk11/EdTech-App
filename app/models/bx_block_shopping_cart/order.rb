module BxBlockShoppingCart
  class Order < ApplicationRecord
    include Wisper::Publisher
    self.table_name = :shopping_cart_orders

    BUFFER_TIME = 20 # in minute

    # order status are
    # upcomming = 'scheduled', ongoing = 'on_going', history = 'cancelled or completed
    enum status: {"scheduled" => 0, "on_going" => 1, "cancelled" => 2, "completed" => 3}

    has_many :order_items, class_name: "BxBlockShoppingCart::OrderItem"
    belongs_to :address, class_name: "BxBlockAddress::Address", optional: true
    belongs_to :customer, class_name: "AccountBlock::Account", foreign_key: :customer_id

    validate :check_order_status, if: proc { |a| !a.new_record? }

    before_create :assign_default_order_status

    scope :todays_order, -> { where(slot_start_time: Date.today.strftime("%d/%m/%y")) }
    scope :completed_order, -> { where(status: "completed") }
    scope :completed_cancelled, -> { where(status: ["completed", "cancelled"]) }
    private

    def assign_default_order_status
      self.status = "scheduled"
    end

    def check_order_status
      if status_was == "completed"
        errors.add(
          :invalid_request, "Your order is finished, you can not update it now"
        )
      end
    end
  end
end
