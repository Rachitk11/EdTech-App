class RemoveSchoolRegIdFromSchools < ActiveRecord::Migration[6.0]
  def change
    remove_column :schools, :school_reg_id, :string
  end
end
