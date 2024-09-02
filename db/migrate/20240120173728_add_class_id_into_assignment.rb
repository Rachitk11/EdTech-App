class AddClassIdIntoAssignment < ActiveRecord::Migration[6.0]
  def change
  	add_column :assignments, :school_class_id, :integer
  end
end
