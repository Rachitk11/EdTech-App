# frozen_string_literal: true

module BxBlockCategories
  class ErrorSerializer < BuilderBase::BaseSerializer
    attribute :errors do |coupon|
      coupon.errors.as_json
    end
  end
end
