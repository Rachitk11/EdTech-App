class AddSubjectIdIntoClassDivision < ActiveRecord::Migration[6.0]
  def change
  	add_column :class_divisions, :subject_ids, :integer, array: true, default: []
  	add_column :class_divisions, :subject_teacher_ids, :integer, array: true, default: []
  end
end
