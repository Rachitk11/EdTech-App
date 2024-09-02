# frozen_string_literal: true
# This migration comes from bx_block_profile_bio (originally 20210216123724)

# remove column age range
class RemoveColumnsAgeRangeAndHeightFromPreferences < ActiveRecord::Migration[6.0]
  def change
    remove_column :preferences, :age_range
    remove_column :preferences, :height
  end
end
