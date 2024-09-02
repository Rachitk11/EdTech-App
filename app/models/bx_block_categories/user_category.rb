# frozen_string_literal: true

module BxBlockCategories
  class UserCategory < ApplicationRecord
    self.table_name = :user_categories

    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :category
  end
end
