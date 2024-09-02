# frozen_string_literal: true

module BxBlockCategories
  class UserSubCategory < ApplicationRecord
    self.table_name = :user_sub_categories

    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :sub_category
  end
end
