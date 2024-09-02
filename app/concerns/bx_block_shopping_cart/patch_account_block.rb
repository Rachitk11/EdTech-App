module BxBlockShoppingCart
  module PatchAccountBlock
    extend ActiveSupport::Concern

    included do
      has_many :orders, class_name: "BxBlockShoppingCart::Order", foreign_key: "customer_id", dependent: :destroy
      has_many_attached :images
    end
  end
end
