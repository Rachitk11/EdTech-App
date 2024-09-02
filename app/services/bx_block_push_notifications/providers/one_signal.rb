require 'net/http'

module BxBlockPushNotifications
  module Providers
    class OneSignal
      API_URL = "https://onesignal.com/api/v1/notifications"

      class << self
        def send_push_notification(title:, message:, user_ids:, app_url:)
          uri = URI.parse(API_URL)

          http = Net::HTTP.new(uri.host, uri.port)

          http.use_ssl = true
          request = Net::HTTP::Post.new(
            uri.path,
            'Content-Type'  => 'application/json;charset=utf-8',
            'Authorization' => "Basic #{auth_token}"
          )
          request.body = body(
            title: title, message: message, user_ids: user_ids, app_url: app_url
          ).to_json
          response = http.request(request)
          JSON.parse(response.read_body)
        end

        private

        def body(title:, message:, user_ids:, app_url:)
          {
            'app_id' => application_id,
            'contents' => {'en' => message},
            'headings' => {'en' => title },
            'app_url' =>  app_url,
            'include_player_ids' => user_ids
          }
        end

        def application_id
          Rails.configuration.x.push_notifications.application_id
        end

        def auth_token
          Rails.configuration.x.push_notifications.auth_token
        end
      end
    end
  end
end
