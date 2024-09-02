# BxBlockContentManagement::CategoryImportService.call(xlsx, error_tracker)

module BxBlockContentManagement
  class ContentImportService
    extend Base

    class << self

      def call(xlsx, error_tracker, current_user_id)
        @current_user_id = current_user_id
        super(xlsx, 'content_sheet', error_tracker)
      end

      def import_data
        @sheet_content.each do |sheet_content|
          build_value = build_attributes(sheet_content)

          category = BxBlockCategories::Category.find_by('lower(name) = ?', strip_downcase(build_value[:category_name]))
          unless category.present?
            add_errors(
              "can't find category with this name '#{build_value[:category_name]}'",
              sheet_content[:heading], sheet_content[:sn], 'content', 'heading'
            )
          end

          sub_category = BxBlockCategories::SubCategory.find_by(
            'lower(name) = ?', strip_downcase(build_value[:sub_category_name])
          )
          unless sub_category.present?
            add_errors(
              "can't find sub category with this name '#{build_value[:sub_category_name]}'",
              sheet_content[:heading], sheet_content[:sn], 'content', 'heading'
            )
          end

          content_type = BxBlockContentManagement::ContentType.find_by(
            'lower(name) = ?', strip_downcase(build_value[:content_type_name])
          )
          unless content_type.present?
            add_errors(
              "can't find content type with this name '#{build_value[:content_type]}'",
              sheet_content[:heading], sheet_content[:sn], 'content', 'heading'
            )
          end

          language = BxBlockLanguageOptions::Language.find_by(
            'lower(name) = ?', strip_downcase(build_value[:language])
          )
          unless language.present?
            add_errors(
              "can't find language with this name '#{build_value[:category_name]}'",
              sheet_content[:heading], sheet_content[:sn], 'content', 'heading'
            )
          end

          tags = build_value[:tags]&.split(",")

          if category.present? && sub_category.present? && content_type.present? && language.present?
            BxBlockContentManagement::CreateContentService.create_content(
              content_type, sheet_content, sub_category, language, category, tags, @current_user_id, self
            )
          end
        end
      end

      def get_headers
        {
          sn: 'sn',
          id: 'id',
          category_name: 'category_name',
          sub_category_name: 'sub_category_name',
          tags: 'tags',
          searchable_text: 'searchable_text',
          publish_date: 'publish_date',
          status: 'status',
          language: 'language',
          content_type_name: "content_type_name",
          author_id: "author_id",
          heading: "heading",
          description: "description",
          affiliation: "affiliation",
          separate_section: "separate_section",
          hyperlink: "hyperlink"
        }
      end
    end
  end
end
