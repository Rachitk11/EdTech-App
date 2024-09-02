# This migration comes from bx_block_profile (originally 20220921073608)
# This migration comes from bx_block_profile (originally 20210317092341)
class CurrentstatusIndustry < ActiveRecord::Migration[6.0]
  def change
    create_table :current_status_industries do |t|
      t.integer :current_status_id
      t.integer :industry_id
      t.timestamps
    end
  end
end
