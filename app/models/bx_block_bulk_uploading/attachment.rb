# frozen_string_literal: true

module BxBlockBulkUploading
  class Attachment < BxBlockBulkUploading::ApplicationRecord
    self.table_name = :attachments
    include Wisper::Publisher

    OPTIONS = %i[processing completed failed].freeze
    enum status: OPTIONS

    has_many_attached :files
    belongs_to :account, class_name: "AccountBlock::Account"

    validates :files, limit: {max: 100},
      size: {less_than: 5.megabytes, message: "Size of individual file should be less than 5 MB"}
  end
end
