# This migration comes from bx_block_profile (originally 20220921073616)
# This migration comes from bx_block_profile (originally 20210318135411)
class CareerExperienceSystemExperiences < ActiveRecord::Migration[6.0]
  def change
    create_table :career_experience_system_experiences do |t|
      t.integer :career_experience_id
      t.integer :syatem_experience_id
      t.timestamps
    end
  end
end
