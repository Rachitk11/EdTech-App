# frozen_string_literal: true

module BxBlockCategories
  class SubCategorySerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :created_at, :updated_at

    attribute :categories, if: proc { |_record, params|
      params && params[:categories] == true
    }
  end
end
