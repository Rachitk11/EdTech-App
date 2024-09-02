class AddSchoolIdIntoAssignment < ActiveRecord::Migration[6.0]
  def change
  	add_column :assignments, :school_id, :integer
  end
end
