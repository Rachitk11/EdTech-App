module BxBlockAttachment
  module PatchAccountBlockAssociations
    extend ActiveSupport::Concern

    included do
      has_many :attachments, class_name: 'BxBlockAttachment::Attachment', dependent: :destroy
      has_many :file_attachments, class_name: 'BxBlockAttachment::FileAttachment', dependent: :destroy
    end

  end
end
