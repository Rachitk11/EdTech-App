class AddSchoolIdIntoVideosLecture < ActiveRecord::Migration[6.0]
  def change
  	add_column :videos_uploads, :school_id, :integer
  end
end
