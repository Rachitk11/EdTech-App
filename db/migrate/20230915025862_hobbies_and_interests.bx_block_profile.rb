# This migration comes from bx_block_profile (originally 20220921073626)
# This migration comes from bx_block_profile (originally 20210330114837)
class HobbiesAndInterests < ActiveRecord::Migration[6.0]
  def change
    create_table :hobbies_and_interests do |t|
      t.string :title
      t.string :category
      t.text :description
      t.boolean :make_public, :null => false, :default => false
      t.integer :profile_id
      t.timestamps
    end
  end
end
