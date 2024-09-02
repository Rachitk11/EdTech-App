module BxBlockSms
  module Providers
    class Test
      class << self
        def messages
          @messages ||= []
        end

        def clear_messages
          @messages = []
        end

        def send_sms(full_phone_number, text_content)
          messages << {
            from: Rails.configuration.x.sms.from,
            to: full_phone_number,
            content: text_content
          }
        end
      end
    end
  end
end
