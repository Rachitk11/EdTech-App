module BxBlockContentManagement
  class LiveStreamSerializer < BuilderBase::BaseSerializer
    attributes :id, :headline, :comment_section, :created_at, :updated_at
  end
end
