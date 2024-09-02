module BxBlockPushNotifications
  class SendPushNotification
    attr_reader :title, :message, :user_ids, :app_url

    def initialize(title:, message:, user_ids:, app_url: nil)
      @title = title
      @message = message
      @user_ids = user_ids
      @app_url = app_url
    end

    def call
      Provider.send_push_notification(
        title: title, message: message, user_ids: user_ids, app_url: app_url
      )
    end
  end
end
