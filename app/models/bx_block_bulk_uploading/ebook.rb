# frozen_string_literal: true
require 'pdf/reader'
require 'searchkick'
module BxBlockBulkUploading
  class Ebook < BxBlockBulkUploading::ApplicationRecord
    self.table_name = :bx_block_bulk_uploading_ebooks
    include Searchkick

    has_one_attached :excel_file
    has_one_attached :pdf
    has_many_attached :images
    has_many :ebook_allotments, class_name: "BxBlockBulkUploading::EbookAllotment"
    has_many :accounts,  class_name: "AccountBlock::Account", through: :ebook_allotments

    has_many :remove_books, class_name: 'RemoveBook', foreign_key: 'ebook_id'
    has_many :remove_students, through: :remove_books, source: :account
 
    before_save :publication_date_cannot_be_in_the_future
    validates :pdf, attached: true, content_type: ['application/pdf']
    validates :images, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
    validates :title, presence: true, uniqueness: true, length: { maximum: 100 }
    validates :author, presence: true, length: { maximum: 100 }
    validates :edition, presence: true, length: { maximum: 100 }
    validates :description, presence: true, length: { maximum: 300 }
    validates :publisher, presence: true
    validates :board, presence: true
    validates :subject, presence: true
    validates :school_class_id, presence: true
    validates :language, length: { maximum: 70 }
    validates :price, presence: true #, numericality: { greater_than: 0 }
    validate :valid_date_format
    validates_format_of :commission_percentage, with: /\A\d+(\.\d+)?%?\z/, message: 'should be a valid percentage'
    validate :validate_max_images
    

    def pdf_url
      pdf.attached? ? Rails.application.routes.url_helpers.rails_blob_path(pdf, only_path: true) : nil
    end

    # def search_data
    #   {
    #     title: title,
    #     author: author,
    #     publisher: publisher,
    #     subject: subject
    #   }
    # end

    private

    def valid_date_format
	    if publication_date.present? && !publication_date.to_s.match(/\A\d{4}-\d{2}-\d{2}\z/)
	      errors.add(:publication_date, "has an invalid date format. Please use YYYY-MM-DD format.")
	    end
	  end

    def validate_max_images
      return unless images.attached? && images.length > 3

      errors.add(:images, 'cannot have more than 3 attached images')
    end

    def publication_date_cannot_be_in_the_future
      errors.add(:publication_date, "Future date is not allow to select.") if publication_date.present? && publication_date > Date.today
    end
  end
end
 