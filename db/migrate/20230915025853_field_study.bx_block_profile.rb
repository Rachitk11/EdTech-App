# This migration comes from bx_block_profile (originally 20220921073617)
# This migration comes from bx_block_profile (originally 20210319065914)
class FieldStudy < ActiveRecord::Migration[6.0]
  def change
    create_table :field_study do |t|
      t.string :field_of_study
      t.timestamps
    end
  end
end
