# frozen_string_literal: true

require 'razorpay'

module BxBlockPayments
  class RazorpaysController < ApplicationController
    before_action :get_transaction, only: [:show, :update]
    before_action :check_expiry, only: [:update]

    def show
      render json: {transaction:  @transaction }, status: :ok
    end

    def create
      plan = BxBlockPlan::Plan.find(params[:plan_id])
      if plan.present?
        order = Razorpay::Order.create amount: params[:amount].to_i * 100, currency: 'INR', receipt: plan.name
        transaction = current_user.transactions.create(order_id: order.id)
        if transaction.save
          render json: {transaction: transaction}, status: :created
        else
          render json: { error: transaction.errors}, status: :unprocessable_entity
        end
      end
    end

    def update
      order = Razorpay::Order.fetch(params[:order_id])
      if order.status == "created"
        @transaction.update(status: params[:payment_response], razorpay_payment_id: params[:razorpay_payment_id], razorpay_order_id: params[:order_id])
        render json: {transaction: @transaction , message: "Your transaction was successfully Done"}, class_name: "BxBlockPayments::Transaction"
      else
        @transaction.update(status: params[:payment_response], razorpay_payment_id: params[:razorpay_payment_id], razorpay_order_id: params[:order_id])
        render json: {transaction: @transaction, message: "Your transaction was failed.
                      If your amount was deducted, then it will be refunded shortly." }, class_name: "BxBlockPayments::Transaction"
      end
    end


    private

    def check_expiry
      if params[:duration] == "3 Months"
        @expiry = Date.today + 90
      elsif params[:duration] == "6 Months"
        @expiry = Date.today + 180
      elsif params[:duration] == "1 Year"
        @expiry = Date.today + 365
      else
        render json: {error: "Invalid Date"}
      end
    end

    def get_transaction
      @transaction ||= BxBlockPayments::Transaction.find_by(order_id: params[:order_id])
      if @transaction.blank?
        render json: { error: "No transaction found !"}
      end
    end
  end
end
