# frozen_string_literal: true

module BxBlockOrderManagement
  class StateProcess
    # optional args parameter can be omitted, but if you define initialize
    # you must accept the model instance as the first parameter to it.
    attr_accessor :order, :aasm, :user

    def initialize(order, aasm)
      @order = order
      @aasm = aasm
      @user = order.order.account if order.instance_of?(OrderItem)
      @user = order.account if order.instance_of?(Order)
    end

    def call
      event_name = aasm.current_event.to_s
      if (Order::EVENTS.include? event_name) && order.instance_of?(Order)
        a = "#{aasm.to_state}_at"
        order.update(a => Time.current)
      end
      create_trackings if order.instance_of?(OrderItem)
      if OrderStatus.new_statuses.pluck(:status).include? event_name.delete("!")
        status_id = OrderStatus.find_or_create_by(status: event_name.delete("!")).id
        order.update(order_status_id: status_id) unless order.order_status_id == status_id
      end
    end

    private

    def create_trackings
      tracking = Tracking.find_or_create_by(date: DateTime.current, status: aasm.to_state.to_s)
      order.order_trackings.create(tracking_id: tracking.id)
    end
  end
end
# rubocop:enable Metrics/AbcSize
