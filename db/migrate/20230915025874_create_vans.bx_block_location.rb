# This migration comes from bx_block_location (originally 20201007074338)
class CreateVans < ActiveRecord::Migration[6.0]
  def change
    create_table :vans do |t|
      t.string :name
      t.text :bio
      t.boolean :is_offline
      t.timestamps
    end
  end
end
