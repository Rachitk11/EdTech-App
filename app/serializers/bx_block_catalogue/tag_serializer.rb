module BxBlockCatalogue
  class TagSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :created_at, :updated_at
  end
end
