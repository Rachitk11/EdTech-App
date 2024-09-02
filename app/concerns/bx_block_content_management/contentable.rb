module BxBlockContentManagement
  module Contentable
    extend ActiveSupport::Concern

    included do
      has_one :contentable, as: :contentable, dependent: :destroy, inverse_of: :contentable,
              class_name: "BxBlockContentManagement::Content"
    end
  end
end
