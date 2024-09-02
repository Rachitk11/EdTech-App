module BxBlockForgotPassword
  class EmailOtpMailer < ApplicationMailer
    def otp_email
      if params[:incoming_params][:data][:type] == 'Student'
        @account = AccountBlock::Account.find_by(student_unique_id: params[:incoming_params][:data][:unique_id])
      else
        @account = AccountBlock::Account.find_by(email: params[:otp].email)
      end
      @otp = params[:otp]
      @host = Rails.env.development? ? 'http://localhost:3000' : params[:host]
      mail(
          to: @otp.email,
          from: 'builder.bx_dev@engineer.ai',
          subject: 'Your OTP code') do |format|
        format.html { render 'otp_email' }
      end
    end
  end
end
