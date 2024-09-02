# This migration comes from bx_block_datastorage (originally 20230302122849)
class CreateBxBlockDatastorageFileDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_datastorage_file_documents do |t|
    	t.string :title
		t.text :description
		t.integer :document_type, default: 0
		t.references :account, foreign_key: true
		t.timestamps
    end
  end
end