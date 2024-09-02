class AddColumnIdIntoVideosUploads < ActiveRecord::Migration[6.0]
  def change
  	add_column :videos_uploads, :account_id, :integer
  	add_column :videos_uploads, :video_duration, :string
  	add_column :videos_uploads, :class_division_id, :integer
  end
end
