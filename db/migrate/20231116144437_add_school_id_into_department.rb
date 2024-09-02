class AddSchoolIdIntoDepartment < ActiveRecord::Migration[6.0]
  def change
  	add_column :departments, :school_id, :integer
  end
end
