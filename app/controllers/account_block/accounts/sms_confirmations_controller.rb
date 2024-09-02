# frozen_string_literal: true

module AccountBlock
  module Accounts
    class SmsConfirmationsController < ApplicationController
      include BuilderJsonWebToken::JsonWebTokenValidation

      before_action :validate_json_web_token

      def create
        begin
          @sms_otp = SmsOtp.find(@token.id)
        rescue ActiveRecord::RecordNotFound => e
          return render json: {errors: [
            {phone: "Phone Number Not Found"}
          ]}, status: :unprocessable_entity
        end

        if @sms_otp.valid_until < Time.current
          @sms_otp.destroy

          return render json: {errors: [
            {pin: "This Pin has expired, please request a new pin code."}
          ]}, status: :unauthorized
        end

        if @sms_otp.activated?
          return render json: ValidateAvailableSerializer.new(@sms_otp, meta: {
            message: "Phone Number Already Activated"
          }).serializable_hash, status: :ok
        end

        if @sms_otp.pin.to_s == params["pin"].to_s
          @sms_otp.activated = true
          @sms_otp.save

          render json: ValidateAvailableSerializer.new(@sms_otp, meta: {
            message: "Phone Number Confirmed Successfully",
            token: BuilderJsonWebToken.encode(@sms_otp.id)
          }).serializable_hash, status: :ok
        else
          render json: {errors: [
            {pin: "Invalid Pin for Phone Number"}
          ]}, status: :unprocessable_entity
        end
      end
    end
  end
end
