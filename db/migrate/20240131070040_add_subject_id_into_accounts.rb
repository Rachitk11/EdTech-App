class AddSubjectIdIntoAccounts < ActiveRecord::Migration[6.0]
  def change
  	add_column :accounts, :subject_ids, :integer, array: true, default: []
  	add_column :accounts, :subject_teacher_ids, :integer, array: true, default: []
  	add_column :accounts, :subject_teacher_class_ids, :integer, array: true, default: []
  	add_column :accounts, :subject_teacher_division_ids, :integer, array: true, default: []
  end
end
