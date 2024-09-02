module BxBlockShoppingCart
  class OrdersController < ApplicationController
    before_action :get_user, only: %i[show create index]
    before_action :find_order, only: %i[show]

    def index
      orders = if params[:filter_by].present? && params[:filter_by].downcase == "history"
        @customer.orders.completed_cancelled
      elsif params[:filter_by].present?
        @customer.orders.where(status: params[:filter_by])
      end
      render json: {message: "No order present"} and return unless orders.present?
      render json: BxBlockShoppingCart::OrderSerializer.new(
        orders
      ).serializable_hash
    end

    def show
      render json: BxBlockShoppingCart::OrderSerializer.new(@order)
    end

    private

    def get_user
      @customer = AccountBlock::Account.find(@token.id)
      render json: {errors: "Customer is invalid"} and return unless @customer.present?
    end

    def find_order
      @order = @customer.orders.find(params[:id])
    end
  end
end
