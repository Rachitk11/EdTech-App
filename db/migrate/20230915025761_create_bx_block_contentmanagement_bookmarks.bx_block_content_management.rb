# This migration comes from bx_block_content_management (originally 20210715091950)
class CreateBxBlockContentmanagementBookmarks < ActiveRecord::Migration[6.0]
  def change
    create_table :bookmarks do |t|
      t.references :account, null: false, foreign_key: true
      t.references :content, null: false, foreign_key: true
      t.timestamps
    end
  end
end
