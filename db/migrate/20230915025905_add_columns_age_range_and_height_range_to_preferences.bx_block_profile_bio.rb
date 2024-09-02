# frozen_string_literal: true
# This migration comes from bx_block_profile_bio (originally 20210216062131)

# Add age range migration
class AddColumnsAgeRangeAndHeightRangeToPreferences < ActiveRecord::Migration[6.0]
  def change
    add_column :preferences, :age_range_start, :integer
    add_column :preferences, :age_range_end, :integer
    add_column :preferences, :height_range_start, :string
    add_column :preferences, :height_range_end, :string
  end
end
