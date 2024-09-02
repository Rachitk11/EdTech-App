module BxBlockLike
  module PatchBxBlockPostsAssociations
    extend ActiveSupport::Concern

    included do
      belongs_to :account, class_name: "AccountBlock::Account"
      has_many :likes, as: :likeable,
        dependent: :destroy,
        class_name: "BxBlockLike::Like"

      has_many :push_notifications,
        foreign_key: :push_notificable_id,
        class_name: "BxBlockPushNotifications::PushNotification",
        dependent: :destroy
    end
  end
end
