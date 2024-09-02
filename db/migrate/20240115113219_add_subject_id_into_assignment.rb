class AddSubjectIdIntoAssignment < ActiveRecord::Migration[6.0]
  def change
  	add_column :assignments, :subject_id, :integer
  	add_column :assignments, :subject_management_id, :integer
  end
end
