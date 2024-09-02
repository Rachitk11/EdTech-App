# frozen_string_literal: true

module BxBlockOrderManagement
  class OrdersController < BxBlockOrderManagement::ApplicationController
    # before_action :check_order_item, only: %i[show destroy]
    before_action :check_order,
      only: %i[update_payment_source update_order_status update_custom_label edit_custom_label add_address_to_order
        apply_coupon add_order_items remove_order_items]
    before_action :address, only: [:add_address_to_order]

    def index
      @past_orders  = BxBlockOrderManagement::Order.where(account_id: @current_user.id, status:"created").order(created_at: :desc).excluding(@current_user.orders.last)
      @recent_orders = BxBlockOrderManagement::Order.where(account_id: @current_user.id, status: "created").last
      orders = {}
      if  @past_orders.present? || @recent_orders.present?
        orders[:recent_orders] = MyOrderSerializer.new(@recent_orders) if @recent_orders.present?
        orders[:past_orders] =  MyOrderSerializer.new(@past_orders) if @past_orders.present?
        render json: orders
      else
        render json: { message: 'No order record found.' }, status: 200
      end
    end

    def create
      if params[:ebook_id].present? || params[:bundle_management_id].present?
        @res = AddProduct.new(params, @current_user).call
        update_cart_total(@res.data) if @res.success?
        if @res.success? && !@res.data.nil?
          order = Order.includes(order_items: [catalogue: %i[category sub_category brand]]
          ).find(@res.data.id)
          render json: {
            data:
              {
                # coupon_message: if @cart_response.nil? || @cart_response.success?
                #                   nil
                #                 else
                #                   @cart_response.msg
                #                 end,
                order: OrderSerializer.new(
                  order,
                  {
                    params: {
                      user: @current_user,
                      host: request.protocol + request.host_with_port
                    }
                  }
                )
              }
          }, status: "200"
        else
          render json: {errors: @res.msg}, status: @res.code
        end
      else
        render json: {msg: "ebook must be define"}, status: 422
      end
    end

    def show
      @order = Order.find_by(account_id: @current_user.id, id: params[:order_id])
      if @order.present?
        render json: MyOrderSerializer.new(
          @order,
          {params: {order: true, host: request.protocol + request.host_with_port}}
        ).serializable_hash, status: :ok
      else
        render json: {message: "Order ID does not exist (or) Order Id does not belong to the current user"}, status: 404
      end
    end

    # def update_order_status
    #   if @order.in_cart? || @order.cancelled?
    #     render json: {error: "Your order is in cart."},
    #       status: :unprocessable_entity
    #   else
    #     ActiveRecord::Base.transaction do
    #       @order.update!(status: params[:status])
    #       render json: OrderSerializer.new(@order, serializable_options), status: 200
    #     end
    #   end
    # end

    # def cancel_order
    #   order = Order.find_by({account_id: @current_user.id, id: params[:order_id]})
    #   render json: {errors: ["Record not found"]}, status: 404 and return unless order.present?

    #   order_status_id = OrderStatus.find_or_create_by(
    #     status: "cancelled", event_name: "cancel_order"
    #   ).id
    #   if order.in_cart?
    #     render json: {error: "Your order is in cart. so no need to cancel it"},
    #       status: :unprocessable_entity
    #   elsif order.status == "cancelled"
    #     render json: {message: "Order already cancelled"},
    #       status: :ok
    #   else
    #     begin
    #       ActiveRecord::Base.transaction do
    #         order.order_items.map do |a|
    #           a.update(
    #             order_status_id: order_status_id, cancelled_at: Time.current
    #           )
    #         end
    #         if order.full_order_cancelled?
    #           order.update(
    #             order_status_id: order_status_id,
    #             status: "cancelled",
    #             cancelled_at: Time.current
    #           )
    #         end
    #       end
    #     rescue => e
    #       render json: {error: e}
    #     end
    #     render json: {message: "Order cancelled successfully"},
    #       status: :ok
    #   end
    # end

    # def destroy
    #   if @order.account_id == @current_user.id
    #     @order.destroy
    #     if @order.destroyed?
    #       render json: {message: "Order deleted successfully"}, status: :ok
    #     else
    #       render json: "Order ID does not exist", status: 404
    #     end
    #   end
    # end

    # def add_address_to_order
    #   x = AddAddressToOrder.new(params, @current_user).call
    #   @order.update(delivery_address_id: params[:address_id])
    #   render json: {message: x.msg}, status: x.code
    # end

    # def apply_coupon
    #   if @order.status == "in_cart"
    #     @coupon = BxBlockCouponCg::CouponCode.find_by_code(params[:code])
    #     render(json: {message: "Invalid coupon"}, status: 400) && return if @coupon.nil?
    #     if @order.amount.present? && @order.amount < @coupon.min_cart_value
    #       return render json: {message: "Keep shopping to apply the coupon"}, status: 400
    #     end

    #     result = ApplyCoupon.new(@order, @coupon, params).call
    #     render json: {
    #       data: {
    #         coupon: OrderSerializer.new(@order), message: result.msg
    #       }
    #     }, status: 200
    #   else
    #     render json: {message: "Order not is in_cart"}
    #   end
    # end

    # def update_custom_label
    #   if params[:custom_label].present?
    #     if @order.update!(custom_label: params[:custom_label])
    #       render json: OrderSerializer.new(@order, serializable_options), status: 200
    #     end
    #   else
    #     render json: {msg: "custom_label must be define"}, status: 422
    #   end
    # end
    
    # def edit_custom_label
    #   if params[:custom_label].present?
    #     if @order.update!(custom_label: params[:custom_label])
    #       render json: OrderSerializer.new(@order, serializable_options), status: 200
    #     end
    #   else
    #     render json: {msg: "custom_label must be define"}, status: 422
    #   end
    # end

    def remove_order_items
      if @order.status == "in_cart" || @order.status == "created"
        if params[:order_items_ids].present?
          err = []
          msg = []
          if OrderItem.find_by(id: params[:order_items_ids], order_management_order_id: params[:order_id])
            msg << params[:order_items_ids]
          else
            err << params[:order_items_ids]
          end

          if !err.present?
            OrderItem.destroy(msg)
            render json: {message: "Order Items are deleted successfully"}, status: 200
          else
            render json: {message: "Order Items ids are does not exist with #{err}"}, status: 422
          end
        else
          render json: {message: "Order Items ids are does not exist"}, status: 422
        end
      else
        render json: {message: "Order not is in_cart or created"}, status: 422
      end
    end

    def add_order_items
      err = validate_order_items(order_item_params)
      
      if order_status_valid? && err.empty?
        create_order_items
      else
        render_error_message(err)
      end
    end

    private

    def validate_order_items(params)
      errors = []

      params.each do |key, value|
        case key
        when "ebook_id"
          validate_ebook(value, errors)
        when "bundle_management_id"
          validate_bundle_management(value, errors)
        else
          render json: {message: "Items are not found"}, status: 404
        end
      end

      errors.uniq
    end

    def validate_ebook(value, errors)
      if value.present?
        ebook = BxBlockBulkUploading::Ebook.find_by(id: value)
        errors << "ebook does not exist" unless ebook.present?
      else
        errors << "ebook must be defined"
      end
    end

    def validate_bundle_management(value, errors)
      if value.present?
        bundle_management = BxBlockBulkUploading::BundleManagement.find_by(id: value)
        errors << "bundle does not exist" unless bundle_management.present?
      else
        errors << "bundle must be defined"
      end
    end

    def order_status_valid?
      @order.status == "in_cart" || @order.status == "created"
    end

    def create_order_items
      @order.order_items.create!(order_item_params)
      render json: OrderSerializer.new(@order, serializable_options), status: 200
    end

    def render_error_message(err)
      if order_status_valid?
        render json: { message: err }, status: 422
      else
        render json: { message: "Order is not in_cart or created" }, status: 422
      end
    end

    # def address
    #   @address = DeliveryAddress.find_by(id: params[:address_id])
    #   render json: {message: "Delivery ID does not exist"}, status: 404 unless @address
    # end

    # def check_order_item
    #   @order = Order.find_by(account_id: @current_user.id, id: params[:id])
    #   unless @order
    #     render json: {message: "Order ID does not exist (or) Order Id does not belongs to current user"},
    #       status: 404
    #   end
    # end

    def check_order
      @order = Order.find_by(account_id: @current_user.id, id: params[:order_id])
      unless @order
        render json: {message: "Order ID does not exist (or) Order Id does not belongs to current user"},
          status: 404
      end
    end

    def update_cart_total(order)
      @cart_response = UpdateCartValue.new(order, @current_user).call
    end

    # def order_params
    #   params.permit(
    #     :order_number, :amount, :account_id,
    #     :delivery_address_id, :sub_total, :total, :status, :applied_discount, :cancellation_reason, :order_date,
    #     :is_gift, :placed_at, :confirmed_at, :in_transit_at, :delivered_at, :cancelled_at, :refunded_at,
    #     :source, :shipment_id, :delivery_charges, :tracking_url, :schedule_time, :payment_failed_at, :returned_at,
    #     :tax_charges, :deliver_by, :tracking_number, :is_error, :delivery_error_message, :payment_pending_at, :order_status_id,
    #     :is_group, :is_availability_checked, :shipping_charge, :shipping_discount, :shipping_net_amt, :shipping_total, :total_tax,
    #     :razorpay_order_id, :charged, :invoiced, :invoice_id,
    #     :ebook_id, :bundle_management_id, :order_id
    #   )
    # end

    def serializable_options
      {params: {host: request.protocol + request.host_with_port}}
    end

    def order_item_params
      # params.permit(order_items: %i[ebook_id bundle_management_id order_id]).require(:order_items)
      params.require(:order_items).permit(:ebook_id, :bundle_management_id  )
    end
  end
end

# rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/ClassLength, Layout/LineLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
