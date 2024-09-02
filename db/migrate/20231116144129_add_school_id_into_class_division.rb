class AddSchoolIdIntoClassDivision < ActiveRecord::Migration[6.0]
  def change
  	add_column :class_divisions, :school_id, :integer
  end
end
