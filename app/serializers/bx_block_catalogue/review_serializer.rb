module BxBlockCatalogue
  class ReviewSerializer < BuilderBase::BaseSerializer
    attributes :id, :catalogue_id, :rating, :comment, :created_at, :updated_at
  end
end
