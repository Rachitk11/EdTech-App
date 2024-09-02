# frozen_string_literal: true

module BxBlockComments
  class CommentSerializer < BuilderBase::BaseSerializer
    include FastJsonapi::ObjectSerializer
    attributes(:id, :account_id, :commentable_id, :commentable_type, :comment, :created_at, :updated_at, :commentable,
      :account)
  end
end
