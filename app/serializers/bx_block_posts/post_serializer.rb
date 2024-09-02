module BxBlockPosts
  class PostSerializer < BuilderBase::BaseSerializer

    attributes *[
        :id,
        :name,
        :description,
        :body,
        :location,
        :account_id,
        :category_id,
        :sub_category_id,
        :created_at,
        :updated_at
    ]

    attribute :model_name do |object|
      object.class.name
    end

    attribute :images_and_videos do |object, params|
      host = params[:host] || ""
      object.images.attached? ?
        object.images.map { |image|
          {
            id: image.id,
            url: host + Rails.application.routes.url_helpers.rails_blob_url(
              image, only_path: true,
            type: image.blob.content_type.split('/')[0]
            )
          }
        } : []
    end

    attribute :media do |object, params|
      host = params[:host] || ""
      object.media.attached? ?
        object.media.map { |media|
          {
            id: media.id,
            url: host + Rails.application.routes.url_helpers.rails_blob_url(
              media, only_path: true,
            ),
            filename: media.blob[:filename],
            content_type: media.blob[:content_type],
          }
        } : []
    end

    attribute :created_at do |object|
      "#{time_ago_in_words(object.created_at)} ago"
    end
  end
end
