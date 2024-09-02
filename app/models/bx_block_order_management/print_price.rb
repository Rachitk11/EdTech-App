# frozen_string_literal: true

module BxBlockOrderManagement
  class PrintPrice < BxBlockOrderManagement::ApplicationRecord
    validates_uniqueness_of :page_size, scope: :colors
    include PublicActivity::Model
    tracked owner: proc { |controller, model| controller&.current_user }
    scope :single_side, ->(page_size, colors) {
      where("LOWER(page_size) = ? AND LOWER(colors) =? ", page_size.downcase, colors.downcase)
    }
    scope :double_side, lambda { |page_size, colors|
      where("LOWER(page_size) = ? AND LOWER(colors) =? ", page_size.downcase, colors.downcase)
    }
  end
end
