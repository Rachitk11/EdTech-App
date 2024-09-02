module BxBlockContentManagement
  module PatchAccountBlockAssociations
    extend ActiveSupport::Concern

    included do
      has_many :contents_languages, class_name: "BxBlockLanguageOptions::ContentLanguage",
               join_table: "contents_languages", dependent: :destroy
      has_many :languages, -> { content_languages }, class_name: "BxBlockLanguageOptions::Language",
               through: :contents_languages, join_table: "contents_languages"
      has_many :user_sub_categories, class_name: "BxBlockCategories::UserSubCategory",
               join_table: "user_sub_categoeries", dependent: :destroy
      has_many :sub_categories, class_name: "BxBlockCategories::SubCategory", through: :user_sub_categories,
               join_table: "user_sub_categoeries", foreign_key: :foreign_key
      has_many :user_categories, class_name: "BxBlockCategories::UserCategory",
               join_table: "user_categoeries", dependent: :destroy
      has_many :categories, class_name: "BxBlockCategories::Category", through: :user_categories,
               join_table: "user_categoeries", foreign_key: :foreign_key
      has_many :bookmarks, class_name: "BxBlockContentManagement::Bookmark", dependent: :destroy
      has_many :content_followings, class_name: "BxBlockContentManagement::Content",
               through: :bookmarks, source: :content
      has_many :followers, class_name: "BxBlockContentManagement::Follow", dependent: :destroy
    end

  end
end
