# This migration comes from bx_block_dashboardguests (originally 20230124111220)
class CreateDashboardGuests < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_dashboardguests_dashboard_guests do |t|
      t.string :company_name
      t.integer :invest_amount
      t.date :date_of_invest
      t.timestamps
    end
  end
end