module BxBlockCatalogue
  class SubjectManagement < BxBlockCatalogue::ApplicationRecord
    self.table_name = :subject_managements
    belongs_to :class_division, class_name: "BxBlockCategories::ClassDivision",:foreign_key => "class_division_id",  optional: true
    belongs_to :account, class_name: "AccountBlock::Account", optional: true
    belongs_to :subject, class_name: "BxBlockCatalogue::Subject", :foreign_key => "subject_id"
    has_many :videos_lectures, class_name: "BxBlockCatalogue::VideosLecture", dependent: :destroy
    has_many :assignments, class_name: "BxBlockCatalogue::Assignment", dependent: :destroy
  end
end