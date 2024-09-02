# This migration comes from bx_block_content_management (originally 20210407072202)
class CreateContentManagementVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :content_management_videos do |t|
      t.integer :attached_item_id, index: true
      t.string :attached_item_type, index: true
      t.string :video

      t.timestamps
    end
  end
end
