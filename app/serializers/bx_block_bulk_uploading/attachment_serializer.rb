# frozen_string_literal: true

module BxBlockBulkUploading
  class AttachmentSerializer < BuilderBase::BaseSerializer
    attributes(:id, :account_id, :files, :status)

    attribute :files do |object|
      if object.files.present?
        arr = []
        object.files.each do |picture|
          arr << {
            id: picture.id,
            file_name: picture.filename.to_s,
            file_url: Rails.application.routes.url_helpers.rails_blob_url(picture, only_path: true)
          }
        end
        arr
      end
    end

    class << self
      private

      def attachment(object)
        object&.attachment&.service_url if object&.attachment&.attached?
      end
    end
  end
end
