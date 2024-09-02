# frozen_string_literal: true

module BxBlockProfileBio
  module PatchLocationBlock
    extend ActiveSupport::Concern

    included do
      belongs_to :locationable, polymorphic: true
    end
  end
end
