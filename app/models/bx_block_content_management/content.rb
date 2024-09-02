module BxBlockContentManagement
  class Content < ApplicationRecord
    self.table_name = :contents

    MAX_TAG_CHARACTERS = 35

    belongs_to :category, class_name: 'BxBlockCategories::Category', foreign_key: 'category_id'
    belongs_to :sub_category, class_name: 'BxBlockCategories::SubCategory', foreign_key: 'sub_category_id'
    belongs_to :content_type, class_name: 'BxBlockContentManagement::ContentType', foreign_key: 'content_type_id'
    belongs_to :language, class_name: 'BxBlockLanguageOptions::Language', foreign_key: 'language_id'
    belongs_to :contentable, polymorphic: true, inverse_of: :contentable, autosave: true, dependent: :destroy
    belongs_to :author, class_name: 'BxBlockContentManagement::Author', optional: true
    has_many :bookmarks, class_name: "BxBlockContentManagement::Bookmark", dependent: :destroy
    has_many :account_bookmarks, class_name: "AccountBlock::Account", through: :bookmarks, source: :account

    validates :author_id, presence: true, if: -> { self.content_type&.blog? }
    validates :publish_date, presence: true, if: ->{ self.publish? }
    validates :status, presence: true
    validate :validate_publish_date, on: :update
    validate  :validate_status, on: :update
    validate  :validate_content_type, on: :update
    validate :validate_approve_status, on: :update
    validate :max_tag_char_length
    validates :feedback, presence: true, if: -> { self.rejected? }

    scope :operations_l1_content, -> { where(review_status: ["pending", "rejected", "submit_for_review"]) }
    scope :submit_for_review_l1_content, -> { where(review_status: ["submit_for_review"]) }

    attr_accessor :current_user_id


    after_initialize :set_defaults

    accepts_nested_attributes_for :contentable

    scope :non_archived, -> { where(archived: false) }
    scope :archived, -> { where(archived: true) }

    searchkick

    acts_as_taggable_on :tags

    enum status: ["draft", "publish", "disable"]

    enum review_status: ["pending", "submit_for_review", "approve", "rejected"]

    scope :published, -> {publish.where("publish_date < ?", DateTime.current)}
    scope :blogs_content, -> { joins(:content_type).where(content_types: {identifier: 'blog'}) }
    scope :filter_content, ->(categories, sub_categories, content_types) {
      where(category: categories, sub_category: sub_categories, content_type: content_types)
    }
    scope :in_review, -> { where(review_status: "submit_for_review")}

    def contentable_attributes=(attributes)
      self.contentable_type = content_type&.type_class
      if self.contentable_type
        some_contentable = self.contentable_type.constantize.find_or_initialize_by(id: self.contentable_id)
        some_contentable.attributes = attributes
        self.contentable = some_contentable
      end
    end

    def name
      contentable&.name
    end

    def description
      contentable&.description
    end

    def image
      contentable&.image_url
    end

    def video
      contentable&.video_url
    end

    def audio
      contentable&.audio_url
    end

    def study_material
      contentable&.study_material_url
    end

    def search_data
      attributes.merge(
        category_name: self.category.name,
        sub_category_name: self.sub_category.name,
        language_name: self.language.name,
        content_type_name: self.content_type.name,
        contentable: self.contentable,
        tags: self.tags.map(&:name).join(" ")
      )
    end

    private

      def max_tag_char_length
        self.tag_list.each do |tag|
          if tag.length > MAX_TAG_CHARACTERS
            errors[:tag] << "#{tag} must be shorter than #{MAX_TAG_CHARACTERS} characters maximum"
          end
        end
      end

      def validate_status
        if self.draft? && will_save_change_to_status?
          errors.add(:status, "can't be change to draft.")
        end
      end

      def validate_content_type
        errors.add(:content_type_id, "can't be updated") if will_save_change_to_content_type_id?
      end

      def validate_publish_date
        if status_in_database == 'publish' && will_save_change_to_publish_date? && publish_date_in_database.present? &&
            publish_date_in_database <= DateTime.current
          errors.add(:publish_date, "can't be changed after published.")
        end
      end

      def set_defaults
        self.status ||= "draft"
      end

      def validate_approve_status
        if will_save_change_to_status? && self.publish? && !self.approve?
          errors.add(:status, "can't be published if content was not approved.")
        end
      end
  end
end
