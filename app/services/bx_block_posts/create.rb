module BxBlockPosts
  class Create
    def initialize(current_user, post_attributes)
      @current_user = current_user
      @post_attributes = post_attributes
    end

    def execute
      post = @current_user.posts.new(@post_attributes)
      post.save
      post
    end
  end
end
