module BxBlockDatastorage
	class FileDocumentsController < ApplicationController
		include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token

    def create
    	file_documents = current_user.file_documents.new(create_document_params)
			if file_documents.save
				render json: FileDocumentSerializer.new(file_documents).serializable_hash, status: 200
			else
				render json: {errors: format_activerecord_errors(file_documents.errors)}, status: :unprocessable_entity
			end
    end

    def index
    	file_documents = current_user.file_documents.order(created_at: :desc)
    	if file_documents.present?
    		render json: FileDocumentSerializer.new(file_documents).serializable_hash, status: 200
  		else
  			render json: { message:	t('file_document_not_found') },status: :unprocessable_entity
  		end
    end

    def show
    	file_document = FileDocument.find_by(id: params[:id])
    	if file_document.present?
    		render json: FileDocumentSerializer.new(file_document).serializable_hash, status: 200
  		else
  			render json: { message: t('file_document_not_found') },status: :unprocessable_entity
  		end
    end

    def destroy
    	file_document = FileDocument.find_by(id: params[:id])
    	if file_document.present?
    		file_document.destroy
    		render json: { message: "File document successfully removed" }, status: 200
  		else
  			render json: { message: t('file_document_not_found') },status: :unprocessable_entity
  		end
    end

		
    private

    def create_document_params
			params.require(:file_document).permit(:title, :description, :document_type, attachments: [])
		end
	end
end
