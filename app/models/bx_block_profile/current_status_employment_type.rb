module BxBlockProfile
  class CurrentStatusEmploymentType < ApplicationRecord
    self.table_name = :bx_block_profile_current_status_employment_types
    belongs_to :current_status, class_name: "BxBlockProfile::CurrentStatus"
    belongs_to :employment_type, class_name: "BxBlockProfile::EmploymentType"
  end
end