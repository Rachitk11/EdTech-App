module BxBlockAttachment
  class Attachment < BxBlockAttachment::ApplicationRecord
    self.table_name = :attachments
    include Wisper::Publisher

    has_one_attached :attachment
    belongs_to :account, class_name: 'AccountBlock::Account'
    after_create :default_values
    scope :not_expired, -> {where('is_expired = ?',false)}

    def default_values
      self.colour = "Greyscale"
      self.layout = "Portrait"
      self.page_size = "A4"
      self.print_sides = "Both"
      self.scale = "Print all pages"
      self.print_pages_from = 1
      self.print_pages_to = 1
      self.total_pages = 1
    end

    def self.attachment_expire
      attachments = BxBlockAttachment::Attachment.where(
        "created_at + '4 hours'::interval < ? AND is_expired =?", DateTime.now, false
      )
      if attachments.present?
        attachments.each do |attachment|
          broadcast(:attachment_expired, attachment)
          attachment.update_attributes(:is_expired => true)
          if attachment.attachment.attached?
            attachment.attachment.purge
            attachment.destroy
          end
        end
      end

      expired_attachments = BxBlockAttachment::Attachment.where(
        "created_at + '4 hours'::interval < ? AND is_expired =?", DateTime.now, true
      )
      if expired_attachments.present?
        expired_attachments.each do |at|
          at.destroy
        end
      end
    end
  end
end
