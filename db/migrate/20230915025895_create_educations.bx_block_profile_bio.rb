# frozen_string_literal: true
# This migration comes from bx_block_profile_bio (originally 20201214111728)

# create education
class CreateEducations < ActiveRecord::Migration[6.0]
  def change
    create_table :educations do |t|
      t.string :qualification
      t.integer :profile_bio_id

      t.timestamps
    end
  end
end
