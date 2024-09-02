module BxBlockProfile
  class Project < ApplicationRecord
    self.table_name = :bx_block_profile_projects
    belongs_to :profile, class_name: "BxBlockProfile::Profile"
    has_many :associated_projects, class_name: "BxBlockProfile::AssociatedProject"
  end
end