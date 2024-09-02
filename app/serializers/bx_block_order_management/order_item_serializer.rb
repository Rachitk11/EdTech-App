# frozen_string_literal: true

# == Schema Information
#
# Table name: order_items
#
#  id                      :bigint           not null, primary key
#  order_id                :bigint           not null
#  quantity                :integer
#  unit_price              :decimal(, )
#  total_price             :decimal(, )
#  old_unit_price          :decimal(, )
#  status                  :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  catalogue_id            :bigint           not null
#  catalogue_variant_id    :bigint           not null
#  order_status_id         :integer
#  placed_at               :datetime
#  confirmed_at            :datetime
#  in_transit_at           :datetime
#  delivered_at            :datetime
#  cancelled_at            :datetime
#  refunded_at             :datetime
#  manage_placed_status    :boolean          default(FALSE)
#  manage_cancelled_status :boolean          default(FALSE)
#
module BxBlockOrderManagement
  class OrderItemSerializer < BuilderBase::BaseSerializer
    attributes(:id, :order_management_order_id, :quantity, :unit_price, :total_price, :old_unit_price, :status,
       :order_status_id, :placed_at, :confirmed_at, :created_at, :updated_at)#, :in_transit_at, :delivered_at, :cancelled_at, :refunded_at, :manage_placed_status, :manage_cancelled_status,:catalogue_id, :catalogue_variant_id)

    attribute :order, if: proc { |_rec, params| params[:order].present? }
    attribute :order_statuses do |object, params|
      if params.present?
        order = object.order
        {
          order_number: order.order_number,
          placed_at: order.placed_at,
          confirmed_at: order.confirmed_at,
          in_transit_at: order.in_transit_at,
          delivered_at: order.delivered_at,
          cancelled_at: order.cancelled_at,
          refunded_at: order.refunded_at
        }
      end
    end

    # attribute :ebook do |object, params|
    #   if object.present?
    #     BxBlockBulkUploading::EbookSerializer.new(
    #       object.ebook, {params: params}
    #     ).serializable_hash[:data]
    #   end
    # end
  end
end
# rubocop:enable Layout/LineLength
