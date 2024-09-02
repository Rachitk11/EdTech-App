# BxBlockContentManagement::CategoryImportService.call(xlsx, error_tracker)

module BxBlockContentManagement
  class CreateContentService

    class << self

      def create_content(content_type, sheet_content, sub_category, language, category, tags, parent_error_tracker=nil)
        case content_type.type
        when "Text"
          BxBlockContentManagement::TextService.create_content(
            sheet_content,
            create_content_params(
              sheet_content,
              sub_category.id,
              language.id,
              category.id,
              content_type.id,
              tags
            ),
            content_type.identifier,
            parent_error_tracker
          )
        when "Videos"
          BxBlockContentManagement::VideoService.create_content(
            sheet_content,
            create_content_params(
              sheet_content,
              sub_category.id,
              language.id,
              category.id,
              content_type.id,
              tags
            ),
            parent_error_tracker)
        when "Live Stream"
          BxBlockContentManagement::LiveStreamService.create_content(
            sheet_content,
            create_content_params(
              sheet_content,
              sub_category.id,
              language.id,
              category.id,
              content_type.id,
              tags
            ),
            parent_error_tracker
          )
        when "AudioPodcast"
          BxBlockContentManagement::AudioPodcastService.create_content(
            sheet_content,
            create_content_params(
              sheet_content,
              sub_category.id,
              language.id,
              category.id,
              content_type.id,
              tags
            ),
            parent_error_tracker
          )
        when "Test"
          BxBlockContentManagement::TestService.create_content(
            sheet_content,
            create_content_params(
              sheet_content,
              sub_category.id,
              language.id,
              category.id,
              content_type.id,
              tags
            ),
            parent_error_tracker
          )
        when "Epub"
          BxBlockContentManagement::EpubService.create_content(
            sheet_content,
            create_content_params(
              sheet_content,
              sub_category.id,
              language.id,
              category.id,
              content_type.id,
              tags
            ),
            parent_error_tracker
          )
        end
      end

      private

      def create_content_params(content, sub_category_id, language_id, category_id, content_type_id, tags)
        {
          category_id: category_id,
          sub_category_id: sub_category_id,
          language_id: language_id,
          searchable_text: content[:searchable_text],
          content_type_id: content_type_id,
          status: content[:status],
          tag_list: tags
        }
      end
    end
  end
end
