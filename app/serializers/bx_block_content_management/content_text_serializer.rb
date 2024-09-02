module BxBlockContentManagement
  class ContentTextSerializer < BuilderBase::BaseSerializer
    attributes :id, :headline, :content, :images, :videos,:hyperlink, :affiliation ,:created_at, :updated_at
    attributes :images do |object|
      if object.images.present?
        object.images.each do |image|
          image.image_url if image.present?
        end
      else
        []
      end
    end
    attributes :videos do |object|
      if object.videos.present?
        object.videos.each do |video|
          video.video_url if video.present?
        end
      else
        []
      end
    end
  end
end
