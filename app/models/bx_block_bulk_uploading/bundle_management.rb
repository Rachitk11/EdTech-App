# frozen_string_literal: true
# require 'pdf/reader'

module BxBlockBulkUploading
  class BundleManagement < BxBlockBulkUploading::ApplicationRecord
    self.table_name = :bx_block_bulk_uploading_bundles

    has_many_attached :cover_images
    has_and_belongs_to_many :ebooks,
                          join_table: 'bundles_ebooks',
                          class_name: 'BxBlockBulkUploading::Ebook',
                          foreign_key: 'bx_block_bulk_uploading_bundle_id',
                          association_foreign_key: 'bx_block_bulk_uploading_ebook_id'

    validates :title, presence: true, length: { in: 1..100 }
    validates :description, presence: true, length: { in: 1..300 }
    validates :total_pricing, presence: true
    validates :board, presence: true
    validates :school_class_id, presence: true
    validates :cover_images, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
    validate :validate_max_images
    validate :at_least_one_ebook

    def calculate_revised_price
      selected_ebook_prices = self.ebooks.map(&:price)
      self.total_pricing = selected_ebook_prices.sum
    end

    private

    def validate_max_images
      return unless cover_images.attached? && cover_images.length > 3

      errors.add(:cover_images, 'cannot have more than 3 attached cover_images')
    end

    def at_least_one_ebook
      errors.add(:base, 'Select at least one ebook to create bundle!') if ebook_ids.blank?
    end
  end
end
