module BxBlockContentManagement
  class ContentText < ApplicationRecord
    include Contentable

    self.table_name = :content_texts

    validates_presence_of :headline, :content

    has_many :images, as: :attached_item, dependent: :destroy
    has_many :videos, as: :attached_item, dependent: :destroy, class_name: 'BxBlockContentManagement::Video'
    accepts_nested_attributes_for :videos, allow_destroy: true
    accepts_nested_attributes_for :images, allow_destroy: true

    def name
      headline
    end

    def description
      content
    end

    def image_url
      images.first.image_url if images.present?
    end

    def video_url
      videos.first.video_url if videos.present?
    end

    def audio_url
      nil
    end

    def study_material_url
      nil
    end
  end
end
