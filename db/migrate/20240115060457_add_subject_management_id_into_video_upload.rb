class AddSubjectManagementIdIntoVideoUpload < ActiveRecord::Migration[6.0]
  def change
  	add_column :videos_uploads, :subject_management_id, :integer
  end
end
