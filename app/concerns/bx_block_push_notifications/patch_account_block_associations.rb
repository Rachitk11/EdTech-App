module BxBlockPushNotifications
  module PatchAccountBlockAssociations
    extend ActiveSupport::Concern

    included do
      has_many :push_notifications,
        foreign_key: :push_notificable_id,
        class_name: 'BxBlockPushNotifications::PushNotification',
        dependent: :destroy

      has_and_belongs_to_many :categories,
        join_table: :account_categories,
        class_name: 'BxBlockCategories::Category'

      has_many_attached :images
    end
  end
end
