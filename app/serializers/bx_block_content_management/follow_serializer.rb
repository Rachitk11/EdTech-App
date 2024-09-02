module BxBlockContentManagement
  class FollowSerializer < BuilderBase::BaseSerializer
    attributes :id, :account, :content_provider, :created_at, :updated_at
  end
end
