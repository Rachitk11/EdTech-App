module BxBlockDownload
  class DownloadablesController < ApplicationController
    include Rails.application.routes.url_helpers

    before_action :validate_json_web_token, :current_user
    before_action :set_downloadable

    def upload
      if @downloadable.nil?
        @downloadable = BxBlockDownload::Downloadable.new(downloadable_params)
      end
      if params[:files].present?
        validated, invalid_files = validate_files(params[:files])
        if validated
          params[:files].each do |file|
            @downloadable.files.attach(file)
          end
          if @downloadable.save
            render status: :ok, json: { downloadable:  BxBlockDownload::DownloadablesSerializer.new(@downloadable).serializable_hash, message: "File/s uploaded successfully." }
          else
            render status: :unprocessable_entity, json: { errors: @downloadable.errors }
          end
        else
          render status: :bad_request, json: { message: "Not saved! Invalid file format.", files: invalid_files }
        end
      else
        render status: :bad_request, json: { message: "File not selected." }
      end
    end

    def view_downloadables
      unless @downloadable.nil?
        render json: { downloadable: BxBlockDownload::DownloadablesSerializer.new(@downloadable) }
      else
        downloadable_not_found
      end
    end

    def download
      if @downloadable.nil?
        downloadable_not_found
      else
        get_file
        unless @file.nil?
          url = Rails.application.routes.url_helpers.rails_blob_url(@file)
          @downloadable.update(last_download_at: DateTime.now)
          @file.update(downloaded_at: DateTime.now)
          begin
            redirect_to "#{url}"
          rescue => e
            e.inspect
          end
        else
          file_not_found
        end
      end
    end

    def destroy
      if is_downloadable?
        if @downloadable.destroy
          render json: { message: "Downloadable deleted." }
        else
          render json: { message: "something went wrong.", error: @downloadable.errors }
        end
      end
    end
  
    def delete_file
      if is_downloadable?
        get_file
        if @file.nil?
          file_not_found
        else
          @file.purge
          render json: { downloadable: BxBlockDownload::DownloadablesSerializer.new(@downloadable), message: "File deleted." }
        end
      end
    end

    private

    def set_downloadable
      @downloadable = BxBlockDownload::Downloadable.find_by(reference_id: params[:reference_id], reference_type: params[:reference_type])
    end

    def downloadable_params
      params.permit(:files, :reference_type, :reference_id)
    end

    def get_file
      @file = @downloadable.files.find_by(id: params[:file_id])
    end

    def is_downloadable?
      if @downloadable.nil?
        downloadable_not_found
        false
      else
        true
      end
    end

    def downloadable_not_found
      render status: :not_found, json: { errors:{ message: "Downloadable not found." } }
    end

    def file_not_found
      render status: :not_found, json: { message: "File with id #{params[:file_id]} not found." }
    end

    def validate_files(files)
      # add allowed file types
      allowed = ["application/msword","application/vnd.openxmlformats-officedocument.wordprocessingml.document","application/pdf","image/jpeg","image/jpg","image/png", "pdf", "png", "jpg", "jpeg", "doc", "docx"]
      invalid_files = []
      validate = true
      if files.count > 0
        files.each do |file|
          content_type = file.content_type
          if content_type == ""
            content_type = file.original_filename.split(".").last
          end
          unless allowed.include?(content_type)
            invalid_files << (file.original_filename)
            validate = false
          end
        end
      else
        render status: :bad_request, json: { errors: "Select atleast one" }
        return false, invalid_files
      end
      return validate, invalid_files
    end
  end
end
