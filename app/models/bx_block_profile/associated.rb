module BxBlockProfile
  class Associated < ApplicationRecord
    self.table_name = :bx_block_profile_associateds
    has_many :associated_projects, class_name: "BxBlockProfile::AssociatedProject"
  end
end