class ChangeImagesToTextInEbook < ActiveRecord::Migration[6.0]
  def change
  	change_column :bx_block_bulk_uploading_ebooks, :images, :text
  end
end