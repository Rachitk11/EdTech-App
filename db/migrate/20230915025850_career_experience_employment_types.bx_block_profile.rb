# This migration comes from bx_block_profile (originally 20220921073614)
# This migration comes from bx_block_profile (originally 20210318111958)
class CareerExperienceEmploymentTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :career_experience_employment_types do |t|
      t.integer :career_experience_id
      t.integer :employment_type_id
      t.timestamps
    end
  end
end
