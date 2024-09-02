class AddClassIdIntoVideosLecture < ActiveRecord::Migration[6.0]
  def change
  	add_column :videos_uploads, :school_class_id, :integer
  end
end
