# frozen_string_literal: true
# This migration comes from bx_block_profile_bio (originally 20201231105710)

# Add about business migration
class AddColumnAboutBusinessToProfileBios < ActiveRecord::Migration[6.0]
  def change
    add_column :profile_bios, :about_business, :text
  end
end
