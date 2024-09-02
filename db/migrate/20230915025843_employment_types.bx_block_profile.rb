# This migration comes from bx_block_profile (originally 20220921073607)
# This migration comes from bx_block_profile (originally 20210317090912)
class EmploymentTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :employment_types do |t|
      t.string :employment_type_name
      t.timestamps
    end
  end
end
