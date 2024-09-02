# This migration comes from bx_block_profile (originally 20220921073618)
# This migration comes from bx_block_profile (originally 20210319071729)
class EducationalQualificationFieldStudy < ActiveRecord::Migration[6.0]
  def change
    create_table :educational_qualification_field_study do |t|
      t.integer :educational_qualification_id
      t.integer :field_study_id
      t.timestamps
    end
  end
end
