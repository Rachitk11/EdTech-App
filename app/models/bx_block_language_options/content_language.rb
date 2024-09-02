module BxBlockLanguageOptions
  class ContentLanguage < ApplicationRecord
    self.table_name = :contents_languages

    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :language, class_name: "BxBlockLanguageOptions::Language",
               foreign_key: "language_options_language_id"

  end
end
