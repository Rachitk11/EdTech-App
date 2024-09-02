# This migration comes from bx_block_dashboard (originally 20230327090243)
class CreateBxBlockDashboardCandidates < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_dashboard_candidates do |t|
      t.string :name
      t.string :email
      t.string :address

      t.timestamps
    end
  end
end
