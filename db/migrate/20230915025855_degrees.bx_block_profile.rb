# This migration comes from bx_block_profile (originally 20220921073619)
# This migration comes from bx_block_profile (originally 20210319072425)
class Degrees < ActiveRecord::Migration[6.0]
  def change
    create_table :degrees do |t|
      t.string :degree_name
      t.timestamps
    end
  end
end
