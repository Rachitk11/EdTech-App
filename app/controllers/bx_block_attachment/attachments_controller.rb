module BxBlockAttachment
  class AttachmentsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token, :validate_blacklisted_user
    before_action :set_account, only: [:get_user_attachments, :create]
    before_action :set_attachment, only: [:save_print_properties, :set_is_printed]

    def get_user_attachments
      if @account.present?
        if @account.attachments.present?
          @attachments = Array.new
          @account.attachments.order('created_at DESC').each do |attachment|
            if attachment&.attachment&.attached? && attachment.orders&.blank?
              @attachments <<  attachment
            end
          end
          if @attachments.present?
            render json: AttachmentSerializer.new(@attachments).serializable_hash
          else
            return render json: {errors: [
              {account: 'No Attachments for this user'},
            ]}, status: :unprocessable_entity
          end
        else
          return render json: {errors: [
            {account: 'No Attachments for this user'},
          ]}, status: :unprocessable_entity
        end
      else
        return render json: {errors: [
          {account: 'User not found'},
        ]}, status: :unprocessable_entity
      end
    end

    def save_print_properties
      if @attachment.present?
        if params[:attachment_data][:set_all] == "1"
          if @attachment.account.attachments.present?
            # document_count = 0
            params[:attachment_data][:colour] = params[:attachment_data][:colour].capitalize
            params[:attachment_data][:page_size] = params[:attachment_data][:page_size].capitalize
            params[:attachment_data][:print_sides] = params[:attachment_data][:print_sides].capitalize
            @attachment.account.attachments.each do |attachment|
              if attachment&.attachment&.attached?
                if attachment.update_attributes(attachments_params)
                  # document_count += 1
                else
                  render json: {errors: @attachment.errors},
                         status: :unprocessable_entity
                end
              end
            end
            if params[:attachment_data][:total_doc].present? and params[:attachment_data][:total_doc].to_i > 0
              document_count = params[:attachment_data][:total_doc]
              render json: AttachmentSerializer.new(@attachment.account.attachments, meta: {
                message: "All #{document_count} Documents Updated Successfully"
              }).serializable_hash, status: :ok
            end
          end
        else
          params[:attachment_data][:colour] = params[:attachment_data][:colour].capitalize
          params[:attachment_data][:page_size] = params[:attachment_data][:page_size].capitalize
          params[:attachment_data][:print_sides] = params[:attachment_data][:print_sides].capitalize
          if @attachment.update_attributes(attachments_params)
            render json: AttachmentSerializer.new(@attachment, meta: {
              message: "Document Updated Successfully"
            }).serializable_hash, status: :ok
          else
            render json: {errors: @attachment.errors},
                   status: :unprocessable_entity
          end
        end
      else
        return render json: {errors: [
          {account: 'Document not found'},
        ]}, status: :unprocessable_entity
      end
    end

    def set_is_printed
      if @attachment.update_attributes(is_printed: params[:data][:is_printed])
        render json: AttachmentSerializer.new(@attachment).serializable_hash
      else
        return render json: {errors: [
          {account: 'Something went wrong'},
        ]}
      end
    end

    private

    def set_attachment
      @attachment = BxBlockAttachment::Attachment.find(params[:id])
    end

    def set_account
      if params[:data].present?
        @account = AccountBlock::Account.find params[:data][:account_id]
      else
        @account = AccountBlock::Account.find params[:id]
      end
    end

    def attachments_params
      params.require(:attachment_data).permit(:colour, :layout, :page_size, :scale, :print_sides,
                                              :print_pages_from, :print_pages_to, :total_pages,
                                              :is_expired, :attachment)
    end

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end
  end
end
