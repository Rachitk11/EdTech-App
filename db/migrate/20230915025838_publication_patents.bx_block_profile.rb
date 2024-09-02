# This migration comes from bx_block_profile (originally 20220921073602)
# This migration comes from bx_block_profile (originally 20210311133326)
class PublicationPatents < ActiveRecord::Migration[6.0]
  def change
    create_table :publication_patents do |t|
      t.string :title
      t.string :publication
      t.string :authors
      t.string :url
      t.text :description
      t.boolean :make_public, :null => false, :default => false
      t.integer :profile_id

      t.timestamps
    end
  end
end
