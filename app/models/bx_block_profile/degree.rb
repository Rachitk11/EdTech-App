module BxBlockProfile
  class Degree < ApplicationRecord
    self.table_name = :bx_block_profile_degrees
    has_many  :degree_educational_qualifications,
              class_name: "BxBlockProfile::DegreeEducationalQualification"
  end
end