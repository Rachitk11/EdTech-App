class ChangeDepartmentIdIntoAccounts < ActiveRecord::Migration[6.0]
  def change
  	rename_column :accounts, :department_id, :department
  	change_column :accounts, :department, :string
  end
end
