# frozen_string_literal: true
# This migration comes from bx_block_profile_bio (originally 20210610115528)

# Add account id migration
class AddColumnAccountIdToPreferences < ActiveRecord::Migration[6.0]
  def change
    add_column :preferences, :account_id, :integer
  end
end
