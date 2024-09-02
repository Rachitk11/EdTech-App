# frozen_string_literal: true
# This migration comes from bx_block_profile_bio (originally 20210107073339)

# create view profile
class CreateViewProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :view_profiles do |t|
      t.integer :profile_bio_id
      t.integer :view_by_id

      t.timestamps
    end
  end
end
