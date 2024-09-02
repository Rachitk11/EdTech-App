module BxBlockLanguageOptions
  module PatchAccountBlockAssociations
    extend ActiveSupport::Concern

    included do
      belongs_to :app_language, -> { app_languages },
                 class_name: 'BxBlockLanguageOptions::Language',
                 foreign_key: :app_language_id, optional: true
      has_many :contents_languages,
               class_name: 'BxBlockLanguageOptions::ContentLanguage',
               join_table: 'contents_languages', dependent: :destroy
      has_many :languages, -> { content_languages },
               class_name: 'BxBlockLanguageOptions::Language',
               through: :contents_languages, join_table: 'contents_languages'
    end

  end
end
