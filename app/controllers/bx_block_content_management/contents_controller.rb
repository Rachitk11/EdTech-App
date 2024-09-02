module BxBlockContentManagement
  class ContentsController < ApplicationController
    before_action :assign_contents, only: [:index, :show]
    skip_before_action :validate_json_web_token, only: [:get_content_detail, :index, :show,
                                                        :reindex_contents, :run_seeds]
    before_action :authorize_request, only: [:reindex_contents, :run_seeds]
    before_action :set_category, :set_sub_category, :set_content_type, :set_language, only: [:contents]

    def get_content_detail
      @content_type_id = params[:id]
      content_type_obj = BxBlockContentManagement::ContentType.find_by(id: params["id"])
      @content_type = content_type_obj&.type
      @content_name = content_type_obj&.name

      if params[:content_id].present?
        @contentable = BxBlockContentManagement::Content.find_by(id: params[:content_id])&.contentable
      end
      if @content_type.present?
        render 'rails_admin/application/form_template'
      end
    end

    def contents
      tags = params[:tag_list]
      content = BxBlockContentManagement::CreateContentService.create_content(
        @content_type, content_params, @sub_category, @language, @category, tags
      )
      if content.present? && content[:errors].present?
        render json: {errors: content[:errors], status: 404}
      else
        render json: {content: ContentSerializer.new(content).serializable_hash, success: true,
                      message: "Content created successfully!"}
      end
    end

    def index
      filter_content
      if params[:search].present?
        @contents = Content.search(
          params[:search], misspellings: true, page: params[:page], per_page: params[:per_page],
          where: { id: @contents.ids }
        )
      else
        @contents = @contents.page(params[:page]).per(params[:per_page])
      end
      render json: ContentSerializer.new(@contents, serialization_options).serializable_hash, status: :ok
    end

    def show
      @content = @contents.find(params[:id])
      @content.update(view_count: @content.view_count + 1)
      render json: ContentSerializer.new(@content).serializable_hash, status: :ok
    end

    def reindex_contents
      BxBlockContentManagement::Content.reindex
      render json: { message: "Content reindexed Successfully!" }
    end

    def run_seeds
      load Rails.root + "db/seeds.rb"
      render json: { message: "Successfully! run seeds" }
    end

    private

    def assign_contents
      @contents = BxBlockContentManagement::Content.published.includes(
        :category, :sub_category, :content_type, :language
      )
    end

    def set_category
      @category = BxBlockCategories::Category.find_by(id: params[:category_id])
      unless @category.present?
        return render json: {error: "can't find category with this id '#{params[:category_id]}'"}
      end
    end

    def content_params
        params.permit(:category_id, :sub_category_id, :language_id, :author_id, :headline,
                      :description, :feature_article, :feature_video, :searchable_text,
                      :content_type_id, :archived, :status, :publish_date, :tag_list,
                      :heading, :content, :hyperlink, :affiliation, :separate_section,
                      images_attributes: [:image], videos_attributes: [:video],
                      image_attributes: [:image], audio_attributes: [:audio],
                      pdfs_attributes: [:pdf], video_attributes: [:video])
    end

    def set_sub_category
      @sub_category = BxBlockCategories::SubCategory.find_by(id: params[:sub_category_id])
      unless @sub_category.present?
        return render json: {error: "can't find sub category with this id '#{params[:sub_category_id]}'"}
      end
    end

    def set_content_type
      @content_type = BxBlockContentManagement::ContentType.find_by(id: params[:content_type_id])
      unless @content_type.present?
        return render json: {error: "can't find content type with this id '#{params[:content_type_id]}'"}
      end
    end

    def set_language
      @language = BxBlockLanguageOptions::Language.find_by(id: params[:language_id])
      unless @language.present?
        return render json: {error: "can't find language with this id '#{params[:language_id]}'"}
      end
    end

    def filter_content
      params.each do |key, value|
        case key
        when 'content_type'
          @contents = @contents.where(content_types: {id: value})
        when 'category'
          @contents = @contents.where(categories: {id: value})
        when 'date'
          @contents = @contents.where(
            "(publish_date < ?) and (publish_date > ?)", value["to"].to_datetime, value["from"].to_datetime
          )
        when 'feature_article'
          @contents = @contents.where(feature_article: value)
        when 'feature_video'
          @contents = @contents.where(feature_video: value)
        when 'content_language'
          @contents = @contents.where(languages: {id: value})
        when 'sub_category'
          @contents = @contents.where(sub_categories: {id: value})
        when 'tag'
          @contents = @contents.tagged_with(value, any: true)
        when 'content_provider'
          @contents = @contents.where(admin_user_id: value)
        end
      end
    end

    def serialization_options
      assign_json_web_token
      options = {}
      options[:params] = { current_user_id: (current_user&.id)}
      options
    end

    def authorize_request
      return render json: {data: [
        {account: "Please use correct api_access_key."},
      ]}, status: 401 unless Rails.application.secrets.api_access_key == params[:api_access_key]
    end
  end
end
