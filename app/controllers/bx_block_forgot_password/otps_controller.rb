module BxBlockForgotPassword
  class OtpsController < ApplicationController
    def create
      puts " - params = #{params}"
      # Check what type of account we are trying to recover
      json_params = jsonapi_deserialize(params)
      if json_params['email'].present?
        # Get account by email
        account = AccountBlock::EmailAccount
          .where(
            "LOWER(email) = ? AND activated = ?",
            json_params['email'].downcase,
            true
          ).first
        return render json: {
          errors: [{
            otp: 'Account not found',
          }],
        }, status: :not_found if account.nil?

        email_otp = AccountBlock::EmailOtp.new(jsonapi_deserialize(params))
        if email_otp.save
          send_email_for email_otp
          render json: serialized_email_otp(email_otp, account.id),
            status: :created
        else
          render json: {
            errors: [email_otp.errors],
          }, status: :unprocessable_entity
        end
      elsif json_params['full_phone_number'].present?
        # Get account by phone number
        phone = Phonelib.parse(json_params['full_phone_number']).sanitized
        account = AccountBlock::SmsAccount.find_by(
            full_phone_number: phone,
            activated: true
        )
        return render json: {
          errors: [{
            otp: 'Account not found',
          }],
        }, status: :not_found if account.nil?

        sms_otp = AccountBlock::SmsOtp.new(jsonapi_deserialize(params))
        if sms_otp.save
          render json: serialized_sms_otp(sms_otp, account.id), status: :created
        else
          render json: {
            errors: [sms_otp.errors],
          }, status: :unprocessable_entity
        end
      else
        return render json: {
          errors: [{
            otp: 'Email or phone number required',
          }],
        }, status: :unprocessable_entity
      end
    end

    private

    def send_email_for(otp_record)
      EmailOtpMailer
        .with(otp: otp_record, host: request.base_url)
        .otp_email.deliver
    end

    def serialized_email_otp(email_otp, account_id)
      token = token_for(email_otp, account_id)
      EmailOtpSerializer.new(
        email_otp,
        meta: { token: token }
      ).serializable_hash
    end

    def serialized_sms_otp(sms_otp, account_id)
      token = token_for(sms_otp, account_id)
      SmsOtpSerializer.new(
        sms_otp,
        meta: { token: token }
      ).serializable_hash
    end

    def token_for(otp_record, account_id)
      BuilderJsonWebToken.encode(
        otp_record.id,
        5.minutes.from_now,
        type: otp_record.class,
        account_id: account_id
      )
    end
  end
end
