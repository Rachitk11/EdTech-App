class AddColumnsToBxBlockBulkUploadingEbooks < ActiveRecord::Migration[6.0]
  def change
  	add_column :bx_block_bulk_uploading_ebooks, :pdf, :string
  	add_column :bx_block_bulk_uploading_ebooks, :school_id, :integer
  	add_column :bx_block_bulk_uploading_ebooks, :board, :integer
  	add_column :bx_block_bulk_uploading_ebooks, :school_class_id, :integer
  	add_column :bx_block_bulk_uploading_ebooks, :subject, :string
  	add_column :bx_block_bulk_uploading_ebooks, :commission_percentage, :string
  	add_column :bx_block_bulk_uploading_ebooks, :images, :string
  	add_column :bx_block_bulk_uploading_ebooks, :publisher_commission, :string
  end
end
