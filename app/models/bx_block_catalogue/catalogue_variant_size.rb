module BxBlockCatalogue
  class CatalogueVariantSize < BxBlockCatalogue::ApplicationRecord
    self.table_name = :catalogue_variant_sizes
    validates :name, presence: true
  end
end
