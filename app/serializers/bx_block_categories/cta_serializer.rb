# frozen_string_literal: true

module BxBlockCategories
  class CtaSerializer < BuilderBase::BaseSerializer
    attributes :id, :headline, :description, :category_id, :is_square_cta, :is_long_rectangle_cta,
      :is_text_cta, :is_image_cta, :has_button, :button_text, :redirect_url,
      :visible_on_details_page, :visible_on_home_page, :text_alignment, :button_alignment,
      :long_background_image, :square_background_image, :created_at, :updated_at

    attribute :long_background_image, &:long_background_image_url

    attribute :square_background_image, &:square_background_image_url
  end
end
