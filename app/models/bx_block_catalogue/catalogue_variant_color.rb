module BxBlockCatalogue
  class CatalogueVariantColor < BxBlockCatalogue::ApplicationRecord
    self.table_name = :catalogue_variant_colors
    validates :name, presence: true
  end
end
