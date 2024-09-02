module BxBlockCatalogue
  class Subject < BxBlockCatalogue::ApplicationRecord
    self.table_name = :subjects
    belongs_to :class_division, class_name: "BxBlockCategories::ClassDivision",:foreign_key => "class_division_id",  optional: true
    belongs_to :account, class_name: "AccountBlock::Account", optional: true
    has_many :subject_managements, class_name: "BxBlockCatalogue::SubjectManagement", dependent: :destroy
    validates :subject_name, uniqueness: true, presence: true
  end
end