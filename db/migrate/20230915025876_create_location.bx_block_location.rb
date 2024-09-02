# This migration comes from bx_block_location (originally 20201007165159)
class CreateLocation < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.float :latitude
      t.float :longitude
      t.integer :van_id
    end
  end
end
