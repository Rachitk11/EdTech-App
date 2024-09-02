# frozen_string_literal: true

module BxBlockCategories
  class Cta < ApplicationRecord
    self.table_name = :cta

    belongs_to :category

    mount_uploader :long_background_image, ImageUploader
    mount_uploader :square_background_image, ImageUploader

    enum text_alignment: %w[centre left right]
    enum button_alignment: %w[centre left right], _suffix: true

    validates :headline, :text_alignment, presence: true, if: -> { is_text_cta }
    validates :button_text, :redirect_url, :button_alignment, presence: true,
      if: -> { has_button }

    def name
      headline
    end
  end
end
