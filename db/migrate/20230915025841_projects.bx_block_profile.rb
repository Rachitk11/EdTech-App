# This migration comes from bx_block_profile (originally 20220921073605)
# This migration comes from bx_block_profile (originally 20210315120829)
class Projects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :project_name
      t.date :start_date
      t.date :end_date
      t.string :add_members
      t.string :url
      t.text :description
      t.boolean :make_projects_public, :null => false, :default => false
      t.integer :profile_id

      t.timestamps
    end
  end
end
