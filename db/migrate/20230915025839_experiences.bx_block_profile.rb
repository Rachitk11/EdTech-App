# This migration comes from bx_block_profile (originally 20220921073603)
# This migration comes from bx_block_profile (originally 20210314175528)
class Experiences < ActiveRecord::Migration[6.0]
  def change
    create_table :career_experiences do |t|
      t.string :job_title
      t.date :start_date
      t.date :end_date
      t.string :company_name
      t.text :description
      t.string :add_key_achievements
      t.boolean :make_key_achievements_public, :null => false, :default => false
      t.integer :profile_id

      t.timestamps
    end
  end
end
