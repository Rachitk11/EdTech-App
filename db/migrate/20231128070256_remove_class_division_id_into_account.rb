class RemoveClassDivisionIdIntoAccount < ActiveRecord::Migration[6.0]
  def change
  	remove_column :accounts, :school_class_ids, :integer, array: true, default: []
  	remove_column :accounts, :class_division_ids, :integer, array: true, default: []
  	remove_column :accounts, :department_ids, :integer, array: true, default: []
  end
end
