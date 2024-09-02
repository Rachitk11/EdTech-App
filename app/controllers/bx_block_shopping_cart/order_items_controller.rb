module BxBlockShoppingCart
  class OrderItemsController < ApplicationController
    before_action :get_user, only: [:create, :destroy]
    before_action :find_or_build_order, only: [:create, :destroy]
    before_action :find_order_item, only: [:destroy]
    # before_action :get_service_provider, only: %i[get_booked_time_slots]

    def index
      @cart_orders = BxBlockOrderManagement::Order.where(account_id: @get_user.id, status:"in_cart").order(created_at: :desc)
      if @cart_orders.present?
        render json: { cart_orders: MyOrderSerializer.new(@cart_orders) }
      else
        render json: { message: 'Your cart is empty!' }
    end

    def create
      @order_item = @order.order_items.find_by(ebook_id: params[:order_items][:ebook_id])

      if @order_item.present?
        @order_item.update(order_items_params)
      else
        @order_item = @order.order_items.create(order_items_params)
      end
      if @order_item.errors.present?
        render json: {
          errors: format_activerecord_errors(@order_item.errors)
        }, status: :unprocessable_entity
      else
        @order.reload
        render json: BxBlockShoppingCart::OrderSerializer.new(@order).serializable_hash, status: 201
      end
    end

    # def destroy
    #   if @order_item.destroy
    #     @order.reload
    #     render json: {message: "Order items deleted succesfully!"}, status: :ok
    #   else
    #     render json: {
    #       errors: format_activerecord_errors(@order_item.errors)
    #     }, status: :unprocessable_entity
    #   end
    # end

    private

    def order_items_params
      params.require(:order_items).permit(
        :catalogue_id, :quantity, :taxable,
        :taxable_value, :other_charges
      )
    end

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << {attribute => error}
      end
      result
    end

    def get_user
      @customer = AccountBlock::Account.find(@token.id)
      render json: {errors: "Customer is invalid"} and return unless @customer.present?
    end

    def find_or_build_order
      @order = @customer.orders.where.not(status: ["completed", "cancelled"]).first
      if @order.blank?
        @order = @customer.orders.create
      end
    end

    def find_order_item
      @order_item = @order.order_items.find(params[:id])
    end
  end
end
