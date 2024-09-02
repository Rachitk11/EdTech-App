class RemoveDepartmentIntoSchoolClass < ActiveRecord::Migration[6.0]
  def change
  	remove_column :school_classes, :department, :string
  	remove_column :school_classes, :deparment_name, :string
  end
end
