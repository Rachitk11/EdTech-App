module BxBlockCouponCg
  class CouponCodeGeneratorController < ApplicationController
    before_action :load_coupon, only: [:show, :update, :destroy]

    def create
      coupon = CouponCode.new(coupon_params)
      save_result = coupon.save

      if save_result
        render json: CouponCodeSerializer.new(coupon).serializable_hash,
               status: :ok
      else
        render json: ErrorSerializer.new(coupon).serializable_hash,
               status: :unprocessable_entity
      end
    end

    def show
      return if @coupon.nil?

      render json: CouponCodeSerializer.new(@coupon).serializable_hash,
             status: :ok
    end

    def index
      coupons = CouponCode.all
      serializer = CouponCodeSerializer.new(coupons)

      render json: serializer, status: :ok
    end

    def destroy
      return if @coupon.nil?

      if @coupon.destroy
        render json: {}, status: :ok
      else
        render json: ErrorSerializer.new(@coupon).serializable_hash,
               status: :unprocessable_entity
      end
    end

    def update
      return if @coupon.nil?

      update_result = @coupon.update(coupon_params)

      if update_result
        render json: CouponCodeSerializer.new(@coupon).serializable_hash,
               status: :ok
      else
        render json: ErrorSerializer.new(@coupon).serializable_hash,
               status: :unprocessable_entity
      end
    end

    private

    def load_coupon
      @coupon = CouponCode.find_by(id: params[:id])

      if @coupon.nil?
        render json: {
            message: "Coupon with id #{params[:id]} doesn't exists"
        }, status: :not_found
      end
    end

    def coupon_params
      params.require(:data).permit(:title, :description, :code, :discount_type,
                   :discount, :valid_from, :valid_to, :min_cart_value,
                   :max_cart_value)
    end
  end
end

