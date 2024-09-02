module BxBlockLike
  module PatchAccountBlockAssociations
    extend ActiveSupport::Concern

    included do
      has_many :push_notifications,
        foreign_key: :push_notificable_id,
        class_name: "BxBlockPushNotifications::PushNotification",
        dependent: :destroy
    end
  end
end
