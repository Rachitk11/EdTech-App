# frozen_string_literal: true
# This migration comes from bx_block_profile_bio (originally 20201231121454)

# change column
class ChangeColumnNameAchievementDateToAchievements < ActiveRecord::Migration[6.0]
  def change
    rename_column :achievements, :calendar, :achievement_date
  end
end
