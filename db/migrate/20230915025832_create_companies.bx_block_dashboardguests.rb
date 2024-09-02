# This migration comes from bx_block_dashboardguests (originally 20230419082108)
class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_dashboardguests_companies do |t|
      t.string :company_name
      t.string :company_holder
      t.timestamps
    end
  end
end
