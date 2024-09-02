# This migration comes from bx_block_content_management (originally 20210304094924)
class CreateVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :content_videos do |t|
      t.string :separate_section
      t.string :headline
      t.string :description
      t.string :thumbnails
      t.timestamps
    end
  end
end
