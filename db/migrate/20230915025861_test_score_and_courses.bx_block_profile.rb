# This migration comes from bx_block_profile (originally 20220921073625)
# This migration comes from bx_block_profile (originally 20210330111142)
class TestScoreAndCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :test_score_and_courses do |t|
      t.string :title
      t.string :associated_with
      t.string :score
      t.datetime :test_date
      t.text :description
      t.boolean :make_public, :null => false, :default => false
      t.integer :profile_id
      t.timestamps
    end
  end
end
