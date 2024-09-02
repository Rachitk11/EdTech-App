module AccountBlock
  class EmailValidationMailer < ApplicationMailer
    def activation_email
      @account = params[:account]
      @host = Rails.env.development? ? "http://localhost:3000": ENV['HOST_URL']

      token = encoded_token
      to_email = @account.email || @account.guardian_email 
      @url = "#{@host}/account/accounts/email_confirmation?token=#{token}"
      
      mail(
        to: to_email,
        from: "builder.bx_dev@engineer.ai",
        subject: "Account activation"
      ) do |format|
        format.html { render "activation_email" }
      end
    end

    private

    def encoded_token
      BuilderJsonWebToken.encode @account.id, 10.minutes.from_now
    end
  end
end
