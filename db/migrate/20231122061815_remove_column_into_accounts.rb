class RemoveColumnIntoAccounts < ActiveRecord::Migration[6.0]
  def change
  	remove_column :accounts, :school_class_id, :integer
  	remove_column :accounts, :department_id, :integer
  	remove_column :accounts, :class_division_id, :integer
  end
end
