module BxBlockContentManagement
  class Epub < ApplicationRecord
    include Contentable

    self.table_name = :epubs

    validates_presence_of :heading, :description

    has_many :pdfs, class_name: 'BxBlockContentManagement::Pdf', as: :attached_item, dependent: :destroy
    accepts_nested_attributes_for :pdfs, allow_destroy: true

    def name
      heading
    end

    def image_url
      nil
    end

    def video_url
      nil
    end

    def audio_url
      nil
    end

    def study_material_url
      pdfs.first.pdf_url if pdfs.present?
    end
  end
end
