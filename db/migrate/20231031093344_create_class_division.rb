class CreateClassDivision < ActiveRecord::Migration[6.0]
  def change
    create_table :class_divisions do |t|
    	t.string :division_name
      t.integer :school_class_id
      t.integer :account_id
      t.integer :department_id
      t.timestamps
    end
  end
end
