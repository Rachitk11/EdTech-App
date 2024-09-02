# This migration comes from bx_block_profile (originally 20220921073615)
# This migration comes from bx_block_profile (originally 20210318134533)
class SystemExperiences < ActiveRecord::Migration[6.0]
  def change
    create_table :system_experiences do |t|
      t.string :system_experience
      t.timestamps
    end
  end
end
