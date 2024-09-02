# This migration comes from bx_block_content_management (originally 20210304101434)
class CreatePodcasts < ActiveRecord::Migration[6.0]
  def change
    create_table :audio_podcasts do |t|
      t.string :heading
      t.string :description
      t.timestamps
    end
  end
end
