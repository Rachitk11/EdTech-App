# frozen_string_literal: true

module BxBlockProfileBio
  # view profile serializer
  class ViewProfileSerializer < BuilderBase::BaseSerializer
    attributes(:account_id, :view_by_id, :created_at, :updated_at)

    attribute :full_name do |object|
      [object.viewer&.first_name, object.viewer&.last_name].join(' ')
    end

    attribute :profile_image do |object|
      image_hash = {}
      if object.viewer.images.attached?
        img = object.viewer.images.find_by(default_image: true)
        if img.present?
          image_hash = {
            id: img.id,
            url: Rails.application.routes.url_helpers.url_for(img),
            default_image: img.default_image
          }
        end
      end
      image_hash
    end

    attribute :mutual_friends_count do |object|
      object.mutual_friends&.count
    end
  end
end
