class AddVideoLectureIntoSubjectManagement < ActiveRecord::Migration[6.0]
  def change 
  	add_column :subject_managements, :videos_lecture, :string
  end
end
