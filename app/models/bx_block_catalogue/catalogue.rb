module BxBlockCatalogue
  class Catalogue < BxBlockCatalogue::ApplicationRecord
    ActiveSupport.run_load_hooks(:catalogue, self)
    PAGE = 1
    PER_PAGE = 10

    self.table_name = :catalogues

    enum availability: %i[in_stock out_of_stock]

    belongs_to :category,
      class_name: "BxBlockCategories::Category",
      foreign_key: "category_id"

    belongs_to :sub_category,
      class_name: "BxBlockCategories::SubCategory",
      foreign_key: "sub_category_id"

    belongs_to :brand, optional: true

    has_many :reviews, dependent: :destroy
    has_many :catalogue_variants, dependent: :destroy
    has_and_belongs_to_many :tags, join_table: :catalogues_tags,
      association_foreign_key: "catalogue_tag_id", foreign_key: :catalogue_id

    has_many_attached :images, dependent: :destroy

    accepts_nested_attributes_for :catalogue_variants, allow_destroy: true

    def average_rating
      return 0 if reviews.size.zero?

      total_rating = 0
      reviews.each do |r|
        total_rating += r.rating
      end
      total_rating.to_f / reviews.size.to_f
    end
  end
end
