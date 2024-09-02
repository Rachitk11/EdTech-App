# This migration comes from bx_block_profile (originally 20220921073601)
# This migration comes from bx_block_profile (originally 20210310122501)
class CurrentStatus < ActiveRecord::Migration[6.0]
  def change
    create_table :current_status do |t|
      t.string :most_recent_job_title
      t.string :company_name
      t.text :notice_period
      t.date :end_date
      t.integer :profile_id

      t.timestamps
    end
  end
end

