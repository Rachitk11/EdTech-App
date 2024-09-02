# This migration comes from bx_block_content_management (originally 20210304113611)
class CreateContentTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :content_types do |t|
      t.string :name
      t.integer :type
      t.integer :identifier
      t.integer :rank
      t.timestamps
    end
  end
end
