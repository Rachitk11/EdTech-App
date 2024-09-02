module BxBlockCategories
  class ClassDivision < ApplicationRecord
      self.table_name = :class_divisions
      belongs_to :school_class, class_name: "BxBlockCategories::SchoolClass", optional: true
      has_many :accounts, class_name: "AccountBlock::Account", dependent: :destroy
      has_many :subjects, class_name: "BxBlockCatalogue::Subject"
      has_many :subject_managements, class_name: "BxBlockCatalogue::SubjectManagement", dependent: :destroy
      validates :division_name, presence: true
    	validates :account_id, presence: true, uniqueness: true
  end
end
