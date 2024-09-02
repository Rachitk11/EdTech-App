class AddExcelFileToBxBlockBulkUploadingEbooks < ActiveRecord::Migration[6.0]
  def change
    add_column :bx_block_bulk_uploading_ebooks, :excel_file, :string
  end
end
