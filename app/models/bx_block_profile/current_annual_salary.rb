module BxBlockProfile
  class CurrentAnnualSalary < ApplicationRecord
    self.table_name = :bx_block_profile_current_annual_salaries
    has_many :current_annual_salary_current_status, class_name: "BxBlockProfile::CurrentAnnualSalaryCurrentStatus"
  end
end