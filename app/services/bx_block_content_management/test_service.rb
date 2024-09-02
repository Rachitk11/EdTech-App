module BxBlockContentManagement
  class TestService
    class << self

      def create_content(row, content_params, parent_error_tracker=nil)
        content_exist = BxBlockContentManagement::Content.find_by(id: row[:id])
        if content_exist
          content_exist.update(test_params(row, content_params))
          return content_exist
        else
          content =  BxBlockContentManagement::Content.new(test_params(row, content_params))
          content.save
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

      def test_params(row, content_params)
        content_params.merge(
          publish_date: row[:publish_date],
          feature_article: row[:feature_article],
          feature_video: row[:feature_video],
          contentable_attributes: { headline: row[:heading] || row[:headline], description: row[:description] }
        )
      end

    end
  end
end
