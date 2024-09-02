# This migration comes from bx_block_profile (originally 20220921073624)
# This migration comes from bx_block_profile (originally 20210330063856)
class Awards < ActiveRecord::Migration[6.0]
  def change
    create_table :awards do |t|
      t.string :title
      t.string :associated_with
      t.string :issuer
      t.datetime :issue_date
      t.text :description
      t.boolean :make_public, :null => false, :default => false
      t.integer :profile_id
      t.timestamps
    end
  end
end
