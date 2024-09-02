module BxBlockContentManagement
  class Image < ApplicationRecord
    self.table_name = :images
    mount_uploader :image, ImageUploader

    # Associations
    belongs_to :attached_item, polymorphic: true

    # Validations
    validates_presence_of :image
  end
end
