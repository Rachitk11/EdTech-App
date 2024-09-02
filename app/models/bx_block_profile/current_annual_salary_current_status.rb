module BxBlockProfile
  class CurrentAnnualSalaryCurrentStatus < ApplicationRecord
    self.table_name = :bx_block_profile_current_annual_salary_current_status
    belongs_to :current_status, class_name: "BxBlockProfile::CurrentStatus"
    belongs_to :current_annual_salary, class_name: "BxBlockProfile::CurrentAnnualSalary"
  end
end