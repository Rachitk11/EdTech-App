class AddColumnClassIdTypeIntoAccount < ActiveRecord::Migration[6.0]
  def change
  	add_column :accounts, :school_class_ids, :integer, array: true, default: []
  	add_column :accounts, :class_division_ids, :integer, array: true, default: []
  	add_column :accounts, :department_ids, :integer, array: true, default: []
  end
end
