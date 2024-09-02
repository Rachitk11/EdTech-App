class AddClassDivisionIdIntoSubjectManagements < ActiveRecord::Migration[6.0]
  def change
  	add_column :subject_managements, :class_division_id, :integer
  end
end
