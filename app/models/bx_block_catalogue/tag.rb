module BxBlockCatalogue
  class Tag < BxBlockCatalogue::ApplicationRecord
    self.table_name = :catalogue_tags
    validates :name, presence: true, uniqueness: { case_sensitive: false }
    has_and_belongs_to_many :catalogues, join_table: :catalogues_tags,
      association_foreign_key: :catalogue_id, foreign_key: :catalogue_tag_id
  end
end
