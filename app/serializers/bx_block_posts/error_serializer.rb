module BxBlockPosts
  class ErrorSerializer < BuilderBase::BaseSerializer
    attribute :errors do |post|
      post.errors.as_json
    end
  end
end
