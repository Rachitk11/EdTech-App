class AddDepartmentIntoClassDivision < ActiveRecord::Migration[6.0]
  def change
  	add_column :class_divisions, :department, :string
  end
end
