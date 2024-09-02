module BxBlockCatalogue
  class Review < BxBlockCatalogue::ApplicationRecord
    self.table_name = :catalogue_reviews

    belongs_to :catalogue
  end
end
