module BxBlockProfile
  class SystemExperience < ApplicationRecord
    self.table_name = :bx_block_profile_system_experiences
    has_many :career_experience_system_experiences, class_name: "BxBlockProfile::CareerExperienceSystemExperience"
  end
end
