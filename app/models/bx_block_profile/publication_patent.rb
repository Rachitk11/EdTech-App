module BxBlockProfile
  class PublicationPatent < ApplicationRecord
    self.table_name = :bx_block_profile_publication_patents
    belongs_to :profile, class_name: "BxBlockProfile::Profile"
  end
end