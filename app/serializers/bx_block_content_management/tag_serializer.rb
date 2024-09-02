module BxBlockContentManagement
  class TagSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :taggings_count, :created_at, :updated_at
  end
end
