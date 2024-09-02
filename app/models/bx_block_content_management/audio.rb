module BxBlockContentManagement
  class Audio < ApplicationRecord
    self.table_name = :audios
    mount_uploader :audio, AudioUploader

    # Associations
    belongs_to :attached_item, polymorphic: true

    # Validations
    validates_presence_of :audio
  end
end
