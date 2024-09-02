# frozen_string_literal: true

module BxBlockCategories
  class SubCategory < BxBlockCategories::ApplicationRecord
    self.table_name = :sub_categories

    has_and_belongs_to_many :categories, join_table: :categories_sub_categories, dependent: :destroy
    belongs_to :parent, class_name: "BxBlockCategories::SubCategory", optional: true
    has_many :sub_categories, class_name: "BxBlockCategories::SubCategory",
      foreign_key: :parent_id, dependent: :destroy
    has_many :user_sub_categories, class_name: "BxBlockCategories::UserSubCategory",
      join_table: "user_sub_categoeries", dependent: :destroy
    has_many :accounts, class_name: "AccountBlock::Account", through: :user_sub_categories,
      join_table: "user_sub_categoeries"

    validates :name, uniqueness: true, presence: true
    validate :check_parent_categories

    private

    def check_parent_categories
      errors.add(:base, "Please select categories or a parent.") if categories.blank? && parent.blank?
    end
  end
end
