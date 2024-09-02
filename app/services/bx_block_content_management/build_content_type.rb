module BxBlockContentManagement
  module BuildContentType
    class << self

      def call(content_types = content_types_array)
        content_types.each do |content_type|
          BxBlockContentManagement::ContentType.where('lower(name) = ?', content_type[:name].downcase)
            .or(BxBlockContentManagement::ContentType.where(identifier: content_type[:identifier]))
            .first_or_create(content_type)
        end
      end

      private

      def content_types_array
        [
          {name: "News Articles", type: "Text", identifier: "news_article"},
          {name: "Blogs", type: "Text", identifier: "blog"},
          {name: "Videos (short)", type: "Videos", identifier: "video_short"},
          {name: "Videos (full length)", type: "Videos", identifier: "video_full"},
          {name: "Live Streaming", type: "Live Stream", identifier: "live_streaming"},
          {name: "Audio Podcast", type: "AudioPodcast", identifier: "audio_podcast"},
          {name: "Quiz (No analytics)", type: "Test", identifier: "quiz"},
          {name: "Assessment (with analytics)", type: "Test", identifier: "assessment"},
          {name: "Study Materials (PDFs/ PPTs/ Word)", type: "Epub", identifier: "study_material"}
        ]
      end

    end
  end
end
