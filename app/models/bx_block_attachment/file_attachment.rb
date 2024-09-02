# frozen_string_literal: true

module BxBlockAttachment
  class FileAttachment < BxBlockAttachment::ApplicationRecord
    self.table_name = :bx_block_attachment_file_attachments
    include Wisper::Publisher
    has_one_attached :attachment
    enum content_type: %i[doc jpg pdf mp3 mp4]
    validates :content_type, presence: true
    validates :attachment, presence: true
    validate :attachment_size

    private
    def attachment_size
      return unless attachment.attached?
      if attachment.blob.byte_size > MAXATTACHMENTSIZE.megabytes
        errors.add(:attachment, "size needs to be less than #{MAXATTACHMENTSIZE} MB")
      end
    end
  end
end
