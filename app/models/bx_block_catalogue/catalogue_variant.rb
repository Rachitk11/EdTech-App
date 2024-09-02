module BxBlockCatalogue
  class CatalogueVariant < BxBlockCatalogue::ApplicationRecord
    self.table_name = :catalogue_variants

    belongs_to :catalogue
    belongs_to :catalogue_variant_color, optional: true
    belongs_to :catalogue_variant_size, optional: true

    has_many_attached :images, dependent: :destroy
  end
end
