# frozen_string_literal: true
# This migration comes from bx_block_profile_bio (originally 20210611055613)

# Add account id migration
class AddColumnAccountIdToViewProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :view_profiles, :account_id, :integer
  end
end
