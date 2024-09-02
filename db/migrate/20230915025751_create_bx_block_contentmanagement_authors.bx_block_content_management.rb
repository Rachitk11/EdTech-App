# This migration comes from bx_block_content_management (originally 20210330111628)
class CreateBxBlockContentmanagementAuthors < ActiveRecord::Migration[6.0]
  def change
    create_table :authors do |t|
      t.string :name
      t.text :bio

      t.timestamps
    end
  end
end
