# This migration comes from bx_block_profile (originally 20220921073612)
# This migration comes from bx_block_profile (originally 20210317124218)
class Languages < ActiveRecord::Migration[6.0]
  def change
    create_table :languages do |t|
      t.string :language
      t.string :proficiency
      t.integer :profile_id

      t.timestamps
    end
  end
end
