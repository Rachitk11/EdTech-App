class AddColumnIdIntoAssignments < ActiveRecord::Migration[6.0]
  def change
  	add_column :assignments, :account_id, :integer
  	add_column :assignments, :class_division_id, :integer
  end
end
