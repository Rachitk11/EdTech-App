# frozen_string_literal: true
# This migration comes from bx_block_profile_bio (originally 20201224124726)

# Add friend business migration
class AddColumnsFriendAndBusinessToPreferences < ActiveRecord::Migration[6.0]
  def change
    add_column :preferences, :friend, :boolean, default: true
    add_column :preferences, :business, :boolean, default: true
    add_column :preferences, :match_making, :boolean, default: true
    add_column :preferences, :travel_partner, :boolean, default: true
    add_column :preferences, :cross_path, :boolean, default: false
  end
end
