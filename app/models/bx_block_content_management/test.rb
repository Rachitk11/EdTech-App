module BxBlockContentManagement
  class Test < ApplicationRecord
    include Contentable

    self.table_name = :tests

    validates_presence_of :headline, :description

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
