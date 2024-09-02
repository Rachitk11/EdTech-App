module BxBlockContentManagement
  class AuthorSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :bio, :created_at, :updated_at
    attributes :contents do |object|
      BxBlockContentManagement::ContentSerializer.new(object.contents)
    end
    attributes :image do |object|
      object.image.image_url if object.image.present?
    end
  end
end
