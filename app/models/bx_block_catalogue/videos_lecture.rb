module BxBlockCatalogue
  class VideosLecture < BxBlockCatalogue::ApplicationRecord
    self.table_name = :videos_uploads
    belongs_to :subject_management, class_name: "BxBlockCatalogue::SubjectManagement", optional: true
    has_many :student_videos, class_name: 'BxBlockCatalogue::StudentVideo'
    has_many :accounts, class_name: "AccountBlock::Account", through: :student_videos
    validates_presence_of :title, :description, :video
    validate :validate_video_link

    private

    def validate_video_link
      uri = URI.parse(video)
      errors.add(:video, "must be a valid URL") unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    rescue URI::InvalidURIError
      errors.add(:video, "must be a valid URL")
    end
  end
end
