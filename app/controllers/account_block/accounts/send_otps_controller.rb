# frozen_string_literal: true

module AccountBlock
  module Accounts
    class SendOtpsController < ApplicationController
      def create
        json_params = jsonapi_deserialize(params)
        account = SmsAccount.find_by(
          full_phone_number: json_params["full_phone_number"],
          activated: true
        )

        unless account.nil?
          return render json: {errors: [{
            account: "Account already activated"
          }]}, status: :unprocessable_entity
        end

        @sms_otp = SmsOtp.new(jsonapi_deserialize(params))
        if @sms_otp.save
          render json: SmsOtpSerializer.new(@sms_otp, meta: {
            token: BuilderJsonWebToken.encode(@sms_otp.id)
          }).serializable_hash, status: :created
        else
          render json: {errors: format_activerecord_errors(@sms_otp.errors)},
            status: :unprocessable_entity
        end
      end

      private

      def format_activerecord_errors(errors)
        result = []
        errors.each do |attribute, error|
          result << {attribute => error}
        end
        result
      end
    end
  end
end
