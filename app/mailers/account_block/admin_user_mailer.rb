module AccountBlock
class AdminUserMailer < ApplicationMailer
    def admin_permission_email
      @account = params[:account]
      @host = Rails.env.development? ? "http://localhost:3000": ENV['HOST_URL']

      token = encoded_token
      to_email = @account.email
      @url = "#{@host}/account/accounts/email_confirmation?token=#{token}"
      mail(
        to: to_email,
        from: "builder.bx_dev@engineer.ai",
        subject: "Access Permission"
      ) do |format|
        format.html { render "admin_permission_email" }
      end
    end

    private

    def encoded_token
      BuilderJsonWebToken.encode @account.id, 10.minutes.from_now
    end
end
end