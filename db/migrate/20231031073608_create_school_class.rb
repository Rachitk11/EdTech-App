class CreateSchoolClass < ActiveRecord::Migration[6.0]
  def change
    create_table :school_classes do |t|
      t.integer :school_id
      t.integer :class_number
      t.string :class_division
      t.string :deparment_name
      t.timestamps
    end
  end
end
