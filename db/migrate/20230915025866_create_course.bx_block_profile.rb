# This migration comes from bx_block_profile (originally 20220921073634)
# This migration comes from bx_block_profile (originally 20210816093110)
class CreateCourse < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :course_name
      t.string :duration
      t.string :year
      t.integer :profile_id
      t.timestamps
    end
  end
end
