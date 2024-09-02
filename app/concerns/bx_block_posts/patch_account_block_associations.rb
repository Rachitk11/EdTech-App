module BxBlockPosts
  module PatchAccountBlockAssociations
    extend ActiveSupport::Concern

    included do
      has_many :posts, class_name: 'BxBlockPosts::Post', dependent: :destroy
      has_many_attached :images
    end

  end
end
