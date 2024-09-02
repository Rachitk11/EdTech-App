module BxBlockCatalogue
  class BrandSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :currency, :created_at, :updated_at
  end
end
