# This migration comes from bx_block_dashboardguests (originally 20230419082221)
class AddCompanyRefToDashboardGuests < ActiveRecord::Migration[6.0]
  def change
    add_column :bx_block_dashboardguests_dashboard_guests, :company_id, :bigint
  end
end
