module BxBlockContentManagement
  class ContentSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :description, :image, :video, :audio, :study_material, :category,
               :sub_category, :language, :content_type, :contentable, :feature_article,
               :feature_video, :tag_list, :status, :publish_date, :view_count, :created_at, :updated_at

    attribute :image do |object|
      object.image if object.image.present?
    end

    attribute :video do |object|
      object.video if object.video.present?
    end

    attribute :audio do |object|
      object.audio if object.audio.present?
    end

    attribute :study_material do |object|
      object.study_material if object.study_material.present?
    end

    attributes :contentable do |object|
      case object&.content_type&.type
      when "Live Stream"
        BxBlockContentManagement::LiveStreamSerializer.new(object.contentable)
      when "Videos"
        BxBlockContentManagement::ContentVideoSerializer.new(object.contentable)
      when "Text"
        BxBlockContentManagement::ContentTextSerializer.new(object.contentable)
      when "AudioPodcast"
        BxBlockContentManagement::AudioPodcastSerializer.new(object.contentable)
      when "Test"
        BxBlockContentManagement::TestSerializer.new(object.contentable)
      when "Epub"
        BxBlockContentManagement::EpubSerializer.new(object.contentable)
      end
    end

    class << self
      private
      def current_user_bookmark(record, current_user_id)
        record.bookmarks.where(account_id: current_user_id).present?
      end
    end
  end
end
