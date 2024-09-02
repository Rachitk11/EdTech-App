module BxBlockContentManagement
  class LiveStreamService
    class << self

      def create_content(row, content_params, parent_error_tracker=nil)
        content_exist = BxBlockContentManagement::Content.find_by(id: row[:id])

        if content_exist
          content_exist.update(live_stream_params(row, content_params))
          return content_exist
        else
          content =  BxBlockContentManagement::Content.new(live_stream_params(row, content_params))
          content.save
          if content.errors.present?
            if parent_error_tracker.present?
              error_tracker.add_errors(
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

      def live_stream_params(row, content_params)
        content_params.merge(
          publish_date: row[:publish_date],
          feature_article: row[:feature_article],
          feature_video: row[:feature_video],
          contentable_attributes: {
            headline: row[:heading] || row[:headline],
            description: row[:description],
            comment_section: row[:separate_section] || row[:comment_section]
          }
        )
      end

    end
  end
end
