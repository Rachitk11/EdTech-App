module BxBlockProfile
  class CareerExperienceSystemExperience < ApplicationRecord
    self.table_name = :bx_block_profile_career_experience_system_experiences
    belongs_to :career_experience, class_name: "BxBlockProfile::CareerExperience"
    belongs_to :system_experience, class_name: "BxBlockProfile::SystemExperience"
  end
end