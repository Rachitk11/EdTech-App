class AddClassDivisionIdIntoDepartments < ActiveRecord::Migration[6.0]
  def change
  	add_column :departments, :class_division_id, :integer
  end
end
