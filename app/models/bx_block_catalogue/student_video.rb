module BxBlockCatalogue
  class StudentVideo < BxBlockCatalogue::ApplicationRecord
    self.table_name = :student_videos
    belongs_to :videos_lecture, class_name: 'BxBlockCatalogue::VideosLecture'
    belongs_to :account, class_name: 'AccountBlock::Account'
  end
end
