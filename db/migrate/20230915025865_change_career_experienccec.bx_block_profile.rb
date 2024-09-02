# This migration comes from bx_block_profile (originally 20220921073633)
# This migration comes from bx_block_profile (originally 20210811103146)
class ChangeCareerExperienccec < ActiveRecord::Migration[6.0]
  def change
    remove_column :career_experiences, :currently_working_at, :text
    add_column :career_experiences, :currently_working_here, :boolean, default: false
  end
end
