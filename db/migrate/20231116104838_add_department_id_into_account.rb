class AddDepartmentIdIntoAccount < ActiveRecord::Migration[6.0]
  def change
  	add_column :accounts, :school_class_id, :integer
  	add_column :accounts, :department_id, :integer
  	add_column :accounts, :class_division_id, :integer
  end
end
