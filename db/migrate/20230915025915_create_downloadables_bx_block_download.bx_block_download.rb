# This migration comes from bx_block_download (originally 20230330095538)
class CreateDownloadablesBxBlockDownload < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_download_downloadables do |t|
      t.integer :reference_id, null: false
      t.string :reference_type
      t.datetime :last_download_at
      t.timestamps
    end
  end
end
