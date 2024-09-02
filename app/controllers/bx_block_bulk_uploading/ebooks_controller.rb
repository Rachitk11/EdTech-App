module BxBlockBulkUploading
  class EbooksController < ApplicationController
    before_action :validate_json_web_token, :current_user

    def get_ebooks
      @ebooks = Ebook.all.page(params[:page]).per(params[:per_page])
      if @ebooks.count.positive?
        render json: { message: 'Ebooks listed successfully', ebooks: EbookSerializer.new(@ebooks, serialization_options).serializable_hash, ebooks_count: @ebooks.total_count }, status: :ok
      else
        render json: { message: 'there is no ebooks to show', ebook_count: @ebooks.count }
      end
    end

    def show
      if current_user.present?
        begin
          @ebook = BxBlockBulkUploading::Ebook.find(params[:id])
          render json: { message: 'Ebook Show successfully', ebooks: EbookSerializer.new(@ebook, serialization_options).serializable_hash }, status: :ok
        rescue ActiveRecord::RecordNotFound
          render_not_found("Ebook not found")
        end
      else
        render json: { message: "User Not Found!" }, status: :not_found
      end
    end

    private

    def current_user
      @account = AccountBlock::Account.find_by(id: @token.id)
    end

    def serialization_options
      { params: { host: request.protocol + request.host_with_port } }
    end
  end
end
