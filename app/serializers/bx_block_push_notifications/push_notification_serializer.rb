module BxBlockPushNotifications
  class PushNotificationSerializer < BuilderBase::BaseSerializer
    attributes *[
      :push_notificable_id,
      :push_notificable_type,
      :remarks,
      :is_read,
      :created_at,
      :updated_at
    ]

    attribute :account do |object|
      AccountBlock::SmsAccountSerializer.new(object.account)
    end

    attribute :looking_for do |object|
      object.account&.categories&.map(&:name)
    end

    attribute :profile_image do |object, params|
      image_hash = {}
      img = nil
      img = object.account.images.find_by(default_image: true) if object.account.images.attached?
      image_hash = {
                      id: img.id,
                      url: Rails.application.routes.url_helpers.url_for(img),
                      default_image: img.default_image
                    } if img.present?
      image_hash
    end
  end
end
