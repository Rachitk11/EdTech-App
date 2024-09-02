module BxBlockAnnotations
  class AnnotationsController < ApplicationController
    before_action :current_user
    before_action :get_annotation, only: [:edit, :show, :update, :destroy]

    def index
      @annotation = @account.annotations.ordered_by_id
      response_render(@annotation)
    end

    def all_annotations
      @annotation = BxBlockAnnotations::Annotation.all.ordered_by_id
      response_render(@annotation)
    end

    def create
      @annotation = BxBlockAnnotations::Annotation.new(title: params[:title], description: params[:description], account_id: @account.id)
      if @annotation.save
        response_render(@annotation)
      else
        render json: {
          errors: format_activerecord_errors(@annotation.errors)
        }, status: :unprocessable_entity
      end
    end

    def edit
      response_render(@annotation)
    end

    def show
      response_render(@annotation)
    end

    def update
      @annotation.update(title: params[:title], description: params[:description])
      @annotation.save
      response_render(@annotation)
    end

    def destroy
      @annotation.destroy
      render json:{meta: {message: "Annotation delete is successfully."}}
    end

    private
    def response_render(annotation)
      host = request.base_url
      render json: BxBlockAnnotations::AnnotationSerializer.new(annotation, params: {account: @account, host: host}
      ).serializable_hash, except: :attachment, status: :ok
    end

    def get_annotation
      @annotation = BxBlockAnnotations::Annotation.find params[:id]
    end

    def current_user
      @account = AccountBlock::Account.find_by(id: @token.id)
    end
  end
end
