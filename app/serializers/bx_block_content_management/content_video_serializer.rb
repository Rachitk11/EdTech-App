module BxBlockContentManagement
  class ContentVideoSerializer < BuilderBase::BaseSerializer
    attributes :id, :separate_section, :headline, :description, :thumbnails, :image, :video, :created_at, :updated_at
    attributes :image do |object|
      object.image.image_url if object.image.present?
    end
    attributes :video do |object|
      object.video.video_url if object.video.present?
    end
  end
end
