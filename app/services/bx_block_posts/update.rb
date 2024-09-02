module BxBlockPosts
  class Update
    def initialize(post, post_attributes)
      @post = post
      @post_attributes = post_attributes
    end

    def execute
      @post.assign_attributes(@post_attributes)
      @post.save
      @post
    end
  end
end
