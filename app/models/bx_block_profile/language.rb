module BxBlockProfile
  class Language < ApplicationRecord
    self.table_name = :bx_block_profile_languages
    belongs_to :profile, class_name: "BxBlockProfile::Profile"
    validates :profile_id, presence: true
  end
end
