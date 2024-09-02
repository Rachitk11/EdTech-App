module BxBlockContentManagement
  class Pdf < ApplicationRecord
    self.table_name = :pdfs
    mount_uploader :pdf, PdfUploader

    # Associations
    belongs_to :attached_item, polymorphic: true

    # Validations
    validates_presence_of :pdf
  end
end
