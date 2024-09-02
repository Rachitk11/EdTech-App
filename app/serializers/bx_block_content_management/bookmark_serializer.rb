module BxBlockContentManagement
  class BookmarkSerializer < BuilderBase::BaseSerializer
    attributes :id, :account, :content, :created_at, :updated_at
  end
end
