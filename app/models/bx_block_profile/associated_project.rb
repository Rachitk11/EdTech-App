module BxBlockProfile
  class AssociatedProject < ApplicationRecord
    self.table_name = :bx_block_profile_associated_projects
    belongs_to :project, class_name: "BxBlockProfile::Project"
    belongs_to :associated, class_name: "BxBlockProfile::Associated"
  end
end