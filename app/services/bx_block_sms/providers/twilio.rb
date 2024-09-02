module BxBlockSms
  module Providers
    class Twilio
      class << self
        def send_sms(full_phone_number, text_content)
          client = ::Twilio::REST::Client.new(account_id, auth_token)
          client.messages.create({
                                   from: from,
                                   to: full_phone_number,
                                   body: text_content
                                 })
        end

        def account_id
          Rails.configuration.x.sms.account_id
        end

        def auth_token
          Rails.configuration.x.sms.auth_token
        end

        def from
          Rails.configuration.x.sms.from
        end
      end
    end
  end
end
