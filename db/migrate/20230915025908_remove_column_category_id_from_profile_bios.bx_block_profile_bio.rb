# frozen_string_literal: true
# This migration comes from bx_block_profile_bio (originally 20210217123603)

# remove category id
class RemoveColumnCategoryIdFromProfileBios < ActiveRecord::Migration[6.0]
  def change
    remove_column :profile_bios, :category_id
  end
end
