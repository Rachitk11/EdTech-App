module BxBlockContentManagement
  class LiveStream < ApplicationRecord
    include Contentable

    self.table_name = :live_streams

    validates_presence_of :headline

    def name
      headline
    end

    def image_url
      nil
    end

    def video_url
      nil
    end

    def audio_url
      nil
    end

    def study_material_url
      nil
    end
  end
end
