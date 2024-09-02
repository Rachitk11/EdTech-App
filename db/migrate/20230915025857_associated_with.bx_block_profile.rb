# This migration comes from bx_block_profile (originally 20220921073621)
# This migration comes from bx_block_profile (originally 20210319133216)
class AssociatedWith < ActiveRecord::Migration[6.0]
  def change
    create_table :associateds do |t|
      t.string :associated_with_name
      t.timestamps
    end
  end
end
