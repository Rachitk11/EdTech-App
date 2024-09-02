module BxBlockProfile
  class EducationalQualificationFieldStudy < ApplicationRecord
    self.table_name = :bx_block_profile_educational_qualification_field_study
    belongs_to :field_study, class_name: "BxBlockProfile::FieldStudy"
    belongs_to :educational_qualification, class_name: "BxBlockProfile::EducationalQualification"
  end
end