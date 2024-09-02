class AddDepartmentIntoSchoolClass < ActiveRecord::Migration[6.0]
  def change
  	add_column :school_classes, :department, :string
  end
end
