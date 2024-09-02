require "uri"
require "net/http"

module BxBlockSms
  module Providers
    class Karix
      class << self
        def send_sms(full_phone_number, text_content)
          send_karix_api(full_phone_number, text_content)
        end

        private

        def send_karix_api(full_phone_number, text_content)
          url = URI(karix_message_url)
          https = Net::HTTP.new(url.host, url.port);
          https.use_ssl = true
          request = Net::HTTP::Post.new(url)
          request["Authorization"] = authorization
          request_data = get_request_data(full_phone_number, text_content)
          request["Content-Type"] = "application/json"
          request.body = request_data.to_json
          response = https.request(request)
          puts response.read_body
        end

        def authorization
          ActionController::HttpAuthentication::Basic.encode_credentials(
            Rails.configuration.x.sms.account_id,
            Rails.configuration.x.sms.auth_token
          )
        end

        def get_request_data(full_phone_number, text_content)
          {
            "channel" => "sms",
            "source" => karix_source,
            "destination" => [full_phone_number],
            "content" => {
              "text" => text_content,
            }
          }
        end

        def karix_message_url
          'https://api.karix.io/message/'
        end

        def karix_source
          Rails.configuration.x.sms.from
        end
      end
    end
  end
end
