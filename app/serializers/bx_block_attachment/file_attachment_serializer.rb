# frozen_string_literal: true

module BxBlockAttachment
  class FileAttachmentSerializer < BuilderBase::BaseSerializer
    attributes(:name, :description, :embeded_code, :tag, :content_type, :thumnail, :is_active, :created_at,
               :updated_at, :created_by)

    attribute :url do |object|
      url_for object
    end

    class << self
      private

      def url_for(object)
        object&.attachment&.service_url if object&.attachment&.attached?
      end
    end
  end
end
