# This migration comes from bx_block_annotations (originally 20230510060620)
class CreateBxBlockAnnotations < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_annotations do |t|
      t.string :title
      t.text :description
      t.integer :account_id

      t.timestamps
    end
  end
end
