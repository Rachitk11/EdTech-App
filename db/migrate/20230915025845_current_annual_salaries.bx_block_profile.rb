# This migration comes from bx_block_profile (originally 20220921073609)
# This migration comes from bx_block_profile (originally 20210317102457)
class CurrentAnnualSalaries < ActiveRecord::Migration[6.0]
  def change
    create_table :current_annual_salaries do |t|
      t.string :current_annual_salary
      t.timestamps
    end
  end
end
