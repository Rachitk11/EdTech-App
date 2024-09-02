module BxBlockProfile
  module PatchAccountBlock
    extend ActiveSupport::Concern

    included do
      has_many :profiles, class_name: "BxBlockProfile::Profile"
    end
  end
end
