# This migration comes from bx_block_profile (originally 20220921073622)
# This migration comes from bx_block_profile (originally 20210319133815)
class AssociatedProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :associated_projects do |t|
      t.integer :project_id
      t.integer :associated_id
      t.timestamps
    end
  end
end
