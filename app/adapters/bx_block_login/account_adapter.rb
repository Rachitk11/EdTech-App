module BxBlockLogin
  class AccountAdapter
    include Wisper::Publisher

    def login_account(account_params)
      # case account_params.type
      # when 'sms_account'
      #   phone = Phonelib.parse(account_params.full_phone_number).sanitized
      #   account = AccountBlock::SmsAccount.find_by(
      #     full_phone_number: phone,
      #     activated: true)
      # when 'email_account'
      #   email = account_params.email.downcase

      #   account = AccountBlock::EmailAccount
      #     .where('LOWER(email) = ?', email)
      #     .where(:activated => true)
      #     .first
      # when 'social_account'
      #   account = AccountBlock::SocialAccount.find_by(
      #     email: account_params.email.downcase,
      #     unique_auth_id: account_params.unique_auth_id,
      #     activated: true)
      # end
      if ["Publisher", "School Admin", "Teacher"].include?(account_params.type)
        account = AccountBlock::Account .where("lower(email) = ?", account_params.email.downcase) .joins(:role) .where(roles: { name: account_params.type }) .where(activated: true) .last
        if !account.present?
          broadcast(:Account_does_not_exits)
          return
        end
      end

      if account_params.type == "Student"
        account = AccountBlock::Account.where(student_unique_id: account_params.unique_id).where(activated: true).last
        if !account.present?
          broadcast(:Please_enter_valid_student_id_or_account_not_activated)
          return
        end
       
      end

      wrong_pin = false
      
      if account.pin != account_params.pin
        wrong_pin = true
      end

      if wrong_pin && account.one_time_pin == account_params.pin && account.is_reset
        wrong_pin = false
      end

      if wrong_pin
        broadcast(:Please_enter_valid_pin)
        return
      end

      unless account.present?
        broadcast(:account_not_found)
        return
      end

      if account.present?
        token, refresh_token = generate_tokens(account.id)
        broadcast(:successful_login, account, token, refresh_token)
      end
    end

    def generate_tokens(account_id)
      [
        BuilderJsonWebToken.encode(account_id, 1.day.from_now, token_type: 'login'),
        BuilderJsonWebToken.encode(account_id, 1.year.from_now, token_type: 'refresh')
      ]
    end
  end
end
