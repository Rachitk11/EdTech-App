# This migration comes from bx_block_profile (originally 20220921073604)
# This migration comes from bx_block_profile (originally 20210315120142)
class EducationalQualifications < ActiveRecord::Migration[6.0]
  def change
    create_table :educational_qualifications do |t|
      t.string :school_name
      t.date :start_date
      t.date :end_date
      t.string :grades
      t.text :description
      t.boolean :make_grades_public, :null => false, :default => false
      t.integer :profile_id

      t.timestamps
    end
  end
end
