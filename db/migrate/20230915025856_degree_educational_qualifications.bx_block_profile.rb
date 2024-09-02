# This migration comes from bx_block_profile (originally 20220921073620)
# This migration comes from bx_block_profile (originally 20210319073056)
class DegreeEducationalQualifications < ActiveRecord::Migration[6.0]
  def change
    create_table :degree_educational_qualifications do |t|
      t.integer :educational_qualification_id
      t.integer :degree_id
      t.timestamps
    end
  end
end
