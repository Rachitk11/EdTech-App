# frozen_string_literal: true
# This migration comes from bx_block_profile_bio (originally 20201228051418)

# Add is paid column migration
class AddColumnIsPaidToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :is_paid, :boolean, default: false
  end
end
