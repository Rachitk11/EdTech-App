# frozen_string_literal: true

require "open-uri"
require "tmpdir"
require "libreconv"
require "aws-sdk"
require "aws-sdk-s3"
require "base64"

module BxBlockBulkUploading
  class AttachmentsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :current_user

    def index
      attachments = Attachment.where(account_id: current_user.id)
      attachment_output = []
      attachments.each do |attachment|
        attachment_output << if attachment&.status == "completed"
          AttachmentSerializer.new(attachment, meta: {
            message: "Attachment Created Successfully"
          })
        elsif attachment&.status != "failed"
          AttachmentSerializer.new(attachment, meta: {
            message: "Attachment in progress"
          })

        else
          AttachmentSerializer.new(attachment, meta: {
            message: "Some error occured"
          })
        end
      end
      render json: attachment_output, status: :ok
    end

    def create
      attachment = Attachment.new(account_id: current_user.id, status: "processing")
      unless attachment.save
        render(json: {message: "Attachment not saved"}, status: :unprocessable_entity)
        return
      end

      errors = do_upload(attachment, attachments_params[:files])

      if attachment.reload.status == "completed"
        render json: AttachmentSerializer.new(attachment, meta: {
          message: "Attachment Created Successfully"
        }).serializable_hash, status: :created
      else
        render json: {errors: errors}, status: :unprocessable_entity
      end
    end

    def show
      attachment = Attachment.find(params[:id])
      if attachment&.status == "completed"
        render json: AttachmentSerializer.new(attachment, meta: {
          message: "Bulk upload job done"
        }).serializable_hash, status: :ok
      elsif attachment&.status != "failed"
        render json: {message: "Bulk Upload In Progress"}, status: :ok
      else
        render json: {message: "Some error occured"}, status: :unprocessable_entity
      end
    end

    def destroy
      attachment = Attachment.find(params[:id])
      unless attachment.present?
        return render json: {message: "attachment does not exist."},
          status: :unprocessable_entity
      end
      if attachment.destroy
        render json: {message: "Deleted."}, status: :ok
      else
        render json: {errors: format_activerecord_errors(attachment.errors)},
          status: :unprocessable_entity
      end
    end

    def delete_attachment
      attachment = Attachment.find_by(id: params[:id], account_id: current_user.id)
      if attachment.present?
        file = ActiveStorage::Attachment.find_by(id: params[:file_id], record_id: attachment.id)
        unless file.present?
          return render json: {message: "File does not exist."},
            status: :unprocessable_entity
        end
        if file.destroy
          render json: {message: "Attachment file deleted successfully."}, status: :ok
        else
          render json: {errors: format_activerecord_errors(file.errors)},
            status: :unprocessable_entity
        end
      else
        render json: {message: "Attachment file does not exist with this account"}, status: :unprocessable_entity
      end
    end

    private

    def attachments_params
      params.permit(files: [])
    end

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << {attribute => error}
      end
      result
    end

    def do_upload(attachment, files)
      attachment.update!(files: files, status: "completed")
    rescue
      errors = format_activerecord_errors(attachment.errors)
      attachment.update!(files: [], status: "failed")

      errors
    end
  end
end
