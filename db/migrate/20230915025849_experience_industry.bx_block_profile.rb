# This migration comes from bx_block_profile (originally 20220921073613)
# This migration comes from bx_block_profile (originally 20210318110214)
class ExperienceIndustry < ActiveRecord::Migration[6.0]
  def change
    create_table :career_experience_industry do |t|
      t.integer :career_experience_id
      t.integer :industry_id
      t.timestamps
    end
  end
end
