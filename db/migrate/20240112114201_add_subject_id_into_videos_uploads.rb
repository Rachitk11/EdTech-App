class AddSubjectIdIntoVideosUploads < ActiveRecord::Migration[6.0]
  def change
  	add_column :videos_uploads, :subject_id, :integer
  end
end
