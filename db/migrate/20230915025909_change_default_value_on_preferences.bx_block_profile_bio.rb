# frozen_string_literal: true
# This migration comes from bx_block_profile_bio (originally 20210217124302)

# change prefences
class ChangeDefaultValueOnPreferences < ActiveRecord::Migration[6.0]
  def change
    change_column_default :preferences, :friend, from: true, to: false
    change_column_default :preferences, :business, from: true, to: false
    change_column_default :preferences, :cross_path, from: true, to: false
    change_column_default :preferences, :match_making, from: true, to: false
    change_column_default :preferences, :travel_partner, from: true, to: false
  end
end
