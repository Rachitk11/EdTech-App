module BxBlockProfile
  class CurrentStatus < ApplicationRecord
   self.table_name = :bx_block_profile_current_status
   belongs_to :profile, class_name: "BxBlockProfile::Profile"
   has_many :current_status_industrys, class_name: "BxBlockProfile::CurrentStatusIndustry"
   has_many :current_status_employment_types, class_name: "BxBlockProfile::CurrentStatusEmploymentType"
   has_many :current_annual_salary_current_status, class_name: "BxBlockProfile::CurrentAnnualSalaryCurrentStatus"
  end
end