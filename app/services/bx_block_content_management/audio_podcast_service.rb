module BxBlockContentManagement
  class AudioPodcastService
    class << self

      def create_content(row, content_params, parent=nil)
        content_exist = BxBlockContentManagement::Content.find_by(id: row[:id])
        if content_exist
          content_exist.update(audio_podcast_params(row, content_params))
          return content_exist
        else
          content =  BxBlockContentManagement::Content.new(audio_podcast_params(row, content_params))
          content.save

          if content.errors.present?
            if parent.present?
              parent.add_errors(content.errors.full_messages.to_sentence, row[:heading], row[:sn], 'content', 'heading')
            else
              return {errors: content.errors.full_messages.to_sentence}
            end
          end
          return content
        end
      end

      private

      def audio_podcast_params(row, content_params)
        content_params = content_params.merge(
          publish_date: row[:publish_date],
          feature_article: row[:feature_article],
          feature_video: row[:feature_video],
          contentable_attributes: {heading: row[:heading], description: row[:description]}
        )
        if row[:image_attributes].present? and row[:image_attributes][:image].present?
          content_params[:contentable_attributes][:image_attributes] =  row[:image_attributes]&.to_unsafe_hash
        end
        if row[:audio_attributes].present? and row[:audio_attributes][:audio].present?
          content_params[:contentable_attributes][:audio_attributes] =  row[:audio_attributes]&.to_unsafe_hash
        end
        content_params
      end

    end
  end
end
