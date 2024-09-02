# This migration comes from bx_block_profile (originally 20220921073606)
# This migration comes from bx_block_profile (originally 20210317074811)
class Industry < ActiveRecord::Migration[6.0]
  def change
    create_table :industries do |t|
      t.string :industry_name
      t.timestamps
    end
  end
end
