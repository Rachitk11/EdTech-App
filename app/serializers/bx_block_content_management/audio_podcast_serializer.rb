module BxBlockContentManagement
  class AudioPodcastSerializer < BuilderBase::BaseSerializer
    attributes :id, :heading, :description, :image, :audio, :created_at, :updated_at
    attributes :image do |object|
      object.image.image_url if object.image.present?
    end
    attributes :audio do |object|
      object.audio.audio_url if object.audio.present?
    end
  end
end
