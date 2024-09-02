class CreatBxBlockBulkUploadingBundles < ActiveRecord::Migration[6.0]
  def change
  	create_table :bx_block_bulk_uploading_bundles do |t|
      t.string :title, null: false, limit: 100
      t.text :description, null: false, limit: 300
      t.decimal :total_pricing, null: false
      t.string :formats_available
      t.integer :books_count
      t.json :cover_images

      t.timestamps
    end

    create_table :bundles_ebooks, id: false do |t|
      t.belongs_to :bx_block_bulk_uploading_bundle
      t.belongs_to :bx_block_bulk_uploading_ebook
    end

    add_index :bundles_ebooks, [:bx_block_bulk_uploading_bundle_id, :bx_block_bulk_uploading_ebook_id], unique: true, name: 'index_bundles_ebooks_on_bundle_and_ebook'
  end
end
