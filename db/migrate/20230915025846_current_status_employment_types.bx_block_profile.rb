# This migration comes from bx_block_profile (originally 20220921073610)
# This migration comes from bx_block_profile (originally 20210317103835)
class CurrentStatusEmploymentTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :current_status_employment_types do |t|
      t.integer :current_status_id
      t.integer :employment_type_id
      t.timestamps
    end
  end
end
