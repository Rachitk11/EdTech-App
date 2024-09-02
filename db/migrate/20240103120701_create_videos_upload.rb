class CreateVideosUpload < ActiveRecord::Migration[6.0]
  def change
    create_table :videos_uploads do |t|
    	t.string :title
      t.text :description
      t.string :subject
      t.string :video

      t.timestamps
    end
  end
end
