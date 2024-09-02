module BxBlockCategories
	class SchoolClass < ApplicationRecord
    self.table_name = :school_classes
    belongs_to :school, class_name: "BxBlockCategories::School"
  	has_many :class_divisions, class_name: "BxBlockCategories::ClassDivision", dependent: :destroy
  	accepts_nested_attributes_for :class_divisions, allow_destroy: true, reject_if: :all_blank
    validates_associated :class_divisions
  	validates :class_number,presence: true,  uniqueness: { scope: :school_id, message: "Class with this number already exists in the school." }
    validate :at_least_one_class_division

    private 
      def at_least_one_class_division
        errors.add(:base, 'At least one class division is required.') unless class_divisions.any?
      end
	end
end
