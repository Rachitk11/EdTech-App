class CreateDepartments < ActiveRecord::Migration[6.0]
  def change
    create_table :departments do |t|
    	t.string :name
      t.integer :school_class_id
      t.integer :account_id
      t.string :class_division
      t.timestamps
    end
  end
end