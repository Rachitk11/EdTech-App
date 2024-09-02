module BxBlockCatalogue
  class CataloguesTag < BxBlockCatalogue::ApplicationRecord
    self.table_name = :catalogues_tags

    belongs_to :catalogue
    belongs_to :tag, foreign_key: "catalogue_tag_id"
  end
end
