class AddClassDivisionIdIntoSubject < ActiveRecord::Migration[6.0]
  def change
  	add_column :subjects, :class_division_id, :integer
  end
end
