# frozen_string_literal: true
# This migration comes from bx_block_order_management (originally 20201013132532)

class AddColumnsToBxBlockOrderManagementOrder < ActiveRecord::Migration[6.0]
  def change
    add_reference :order_management_orders, :account, index: true
    add_reference :order_management_orders, :coupon_code, index: true
    add_column :order_management_orders, :delivery_address_id, :bigint
    add_column :order_management_orders, :sub_total, :decimal, default: 0.0
    add_column :order_management_orders, :total, :decimal, default: 0.0
    add_column :order_management_orders, :status, :string
    add_column :order_management_orders, :applied_discount, :decimal, default: 0.0
    add_column :order_management_orders, :cancellation_reason, :text
    add_column :order_management_orders, :order_date, :datetime
    add_column :order_management_orders, :is_gift, :boolean, default: false
    add_column :order_management_orders, :placed_at, :datetime
    add_column :order_management_orders, :confirmed_at, :datetime
    add_column :order_management_orders, :in_transit_at, :datetime
    add_column :order_management_orders, :delivered_at, :datetime
    add_column :order_management_orders, :cancelled_at, :datetime
    add_column :order_management_orders, :refunded_at, :datetime
    add_column :order_management_orders, :source, :string
    add_column :order_management_orders, :shipment_id, :string
    add_column :order_management_orders, :delivery_charges, :string
    add_column :order_management_orders, :tracking_url, :string
    add_column :order_management_orders, :schedule_time, :datetime
    add_column :order_management_orders, :payment_failed_at, :datetime
    add_column :order_management_orders, :returned_at, :datetime
    add_column :order_management_orders, :tax_charges, :decimal, default: 0.0
    add_column :order_management_orders, :deliver_by, :integer
    add_column :order_management_orders, :tracking_number, :string
    add_column :order_management_orders, :is_error, :boolean, default: false
    add_column :order_management_orders, :delivery_error_message, :string
    add_column :order_management_orders, :payment_pending_at, :datetime
    add_column :order_management_orders, :order_status_id, :integer
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize
