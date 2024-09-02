class AddEmployeeIdToSchoolAdmin < ActiveRecord::Migration[6.0]
  def change
  	add_column :accounts, :employee_unique_id, :string
  end
end
