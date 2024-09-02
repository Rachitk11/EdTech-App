# frozen_string_literal: true

module BxBlockComments
  class Comment < BxBlockComments::ApplicationRecord
    self.table_name = :comments
    if ENV['TEMPLATEAPP_DATABASE']
      include PublicActivity::Model
      tracked owner: proc { |controller, _model| controller&.current_user }
    end

    validates :comment, presence: true

    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :commentable, polymorphic: true

    def self.policy_class
      ::BxBlockComments::CommentPolicy
    end
  end
end
