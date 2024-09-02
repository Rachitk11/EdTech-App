class ChangeDataTypeForColumnsInBxBlockBulkUploadingEbooks < ActiveRecord::Migration[6.0]
  def change
  	change_column :bx_block_bulk_uploading_ebooks, :board, :string
  	change_column :bx_block_bulk_uploading_ebooks, :school_class_id, :string
  	change_column :bx_block_bulk_uploading_ebooks, :school_id, :string
  end
end
