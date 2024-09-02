module BxBlockContentManagement
  class ContentTypeSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :type, :identifier, :created_at, :updated_at
  end
end
