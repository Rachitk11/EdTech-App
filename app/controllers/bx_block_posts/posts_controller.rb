module BxBlockPosts
  class PostsController < ApplicationController

    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token
    before_action :check_image_video_formate, only: [:create,:update]
    before_action :check_account_activated
    before_action :check_category, only: [:create,:update]
    before_action :check_sub_category, only: [:create,:update]

    def index
      posts = BxBlockPosts::Post.all
      if posts.present?
        render json: PostSerializer.new(posts, params: {current_user: current_user}).serializable_hash
      else
        render json: {data: []},
            status: :ok
      end
    end

    def create
      service = BxBlockPosts::Create.new(current_user, post_params)
      new_post = service.execute
      if new_post.persisted?
        upload_post_images(new_post,params[:images])if params[:images].present?
        media(new_post,params[:media]) if params[:media].present?
        render json: PostSerializer.new(new_post).serializable_hash,
               status: :ok
      else
        render json: ErrorSerializer.new(new_post).serializable_hash,
               status: :unprocessable_entity
      end
    end

    def show
      post = BxBlockPosts::Post.find_by(id: params[:id])

      return render json: {errors: [
          {Post: 'Not found'},
        ]}, status: :not_found if post.blank?
      json_data = PostSerializer.new(post, params: {current_user: current_user}).serializable_hash
      render json: json_data
    end

    def update
      post = BxBlockPosts::Post.find_by(id: params[:id], account_id: current_user.id)

      return render json: {errors: [
          {Post: 'Not found'},
        ]}, status: :not_found if post.blank?
      post = BxBlockPosts::Update.new(post, post_params).execute

      if post.persisted?
        upload_post_images(post,params[:images])if params[:images].present?
        media(post,params[:media]) if params[:media].present?
        render json: PostSerializer.new(post, params: {current_user: current_user}).serializable_hash
      else
        render json: {errors: format_activerecord_errors(post.errors)},
            status: :unprocessable_entity
      end
    end

    def search
      @posts = Post.where('description ILIKE :search', search: "%#{search_params[:query]}%")
      render json: PostSerializer.new(@posts, params: {current_user: current_user}).serializable_hash, status: :ok
    end

    def destroy
      post = BxBlockPosts::Post.find_by(id: params[:id], account_id: current_user.id)
      render(json: { errors: 'post not found' }, status: :not_found) and return if post.nil?
      if post.destroy
        render json: {message: "Post deleted succesfully!"}, status: :ok
      else
        render json: ErrorSerializer.new(post).serializable_hash,
               status: :unprocessable_entity
      end
    end

    private

    def post_params
      params.permit(
        :name, :description, :body, :category_id,:sub_category_id, :location,
        tag_list: [],
        images: [],
        location_attributes: [:id, :address, :_destroy]
      )
    end

    def search_params
      params.permit(:query)
    end

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end

    def check_image_video_formate
      return if params[:images].blank?
      image_formats = %w(image/jpeg image/jpg image/png)
      video_formats = %w(video/mp4 video/mov video/wmv video/flv video/avi video/mkv video/webm)
      params[:images].each do |image_data|
        content_type = image_data[:content_type]
        if image_formats.exclude?(image_data[:content_type]) && content_type == 'image'
          render json: {errors: ["The image is unsupported type, supported formates are #{image_formats}"]},
            status: :unprocessable_entity
        elsif video_formats.exclude?(image_data[:content_type]) && content_type == 'video'
          render json: {errors: ["The video is unsupported type, supported formates are #{video_formats}"]},
            status: :unprocessable_entity
        end
      end
    end

    def upload_post_images(post,images_params)
      images_to_attach = []

      images_params.each do |image_data|
        if image_data[:data]
          decoded_data = Base64.decode64(image_data[:data].split(',')[0])
          images_to_attach.push(
            io: StringIO.new(decoded_data),
            content_type: image_data[:content_type],
            filename: image_data[:filename]
          )
        end
      end
      post.images.attach(images_to_attach) if images_to_attach.size.positive?
    end

    def media(post,images_params)
      images_to_attach = []

      images_params.each do |image_data|
        if image_data[:data]
          decoded_data = Base64.decode64(image_data[:data].split(',')[0])
          images_to_attach.push(
            io: StringIO.new(decoded_data),
            content_type: image_data[:content_type],
            filename: image_data[:filename]
          )
        end
      end
      post.media.attach(images_to_attach) if images_to_attach.size.positive?
    end

    def check_category
      @category = BxBlockCategories::Category.find_by(id: params[:category_id])
      unless @category
        render json: {message: "Category ID does not exist"},
          status: 404
      end
    end

    def check_sub_category
      @sub_category = BxBlockCategories::SubCategory.find_by(id: params[:sub_category_id])
      unless @sub_category
        render json: {message: "Sub_category ID does not exist"},
          status: 404
      end
    end
  end
end
