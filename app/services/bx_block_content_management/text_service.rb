module BxBlockContentManagement
  class TextService
    class << self
      def create_content(row, content_params, identifier, parent_error_tracker=nil)
        content_exist = BxBlockContentManagement::Content.find_by(id: row[:id])
        if content_exist
          if content_exist.content_type.identifier == 'blog'
            parent_error_tracker.present?  ? save_with_author(row, parent_error_tracker) : save_with_author(row)
            content_exist.update(text_content_params(row, content_params).merge(author_id: row[:author_id]))
          else
            content_exist.update(text_content_params(row, content_params))
          end
          return content_exist
        else
          if identifier == 'blog'
            save_with_author(row, parent_error_tracker)
            content =  BxBlockContentManagement::Content.new(
              text_content_params(row, content_params
              ).merge(author_id: row[:author_id]))
            content.save
          else
            content =  BxBlockContentManagement::Content.new(text_content_params(row, content_params))
            content.save
          end

          if content.errors.present?
            if parent_error_tracker.present?
              parent_error_tracker.add_errors(
                content.errors.full_messages.to_sentence, row[:heading], row[:sn], 'content', 'heading'
              )
            else
              return {errors: content.errors.full_messages.to_sentence}
            end
          end
          return content
        end
      end

      private

      def text_content_params(row, content_params)
        content_params = content_params.merge(
          publish_date: row[:publish_date],
          feature_article: row[:feature_article],
          feature_video: row[:feature_video],
          contentable_attributes: {
            headline: row[:heading] || row[:headline],
            content: row[:description] || row[:content],
            hyperlink: row[:hyperlink],
            affiliation: row[:affiliation]
          }
        )
        if row[:images_attributes].present?
          content_params[:contentable_attributes][:images_attributes] = row[:images_attributes]&.to_unsafe_hash
        end
        if row[:videos_attributes].present?
          content_params[:contentable_attributes][:videos_attributes] = row[:videos_attributes]&.to_unsafe_hash
        end
        content_params
      end

      def save_with_author(row, parent_error_tracker=nil)
        @author = BxBlockContentManagement::Author.find_by(id: row[:author_id])
        (parent_error_tracker ? parent_error_tracker.add_errors(
            "author not find with id '#{row[:author_id]}'",
            row[:heading],
            row[:sn],
            'content',
            'heading'
          ) : (return {errors: "author not find"})
        ) unless @author.present?
      end

    end
  end
end
