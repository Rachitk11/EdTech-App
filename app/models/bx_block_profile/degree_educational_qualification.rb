module BxBlockProfile
  class DegreeEducationalQualification < ApplicationRecord
    self.table_name = :bx_block_profile_degree_educational_qualifications
    belongs_to :degree, class_name: "BxBlockProfile::Degree"
    belongs_to :educational_qualification, class_name: "BxBlockProfile::EducationalQualification"
  end
end