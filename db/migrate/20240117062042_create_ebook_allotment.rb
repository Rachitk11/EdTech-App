class CreateEbookAllotment < ActiveRecord::Migration[6.0]
  def change
    create_table :ebook_allotments do |t|
      t.references :account, null: false, foreign_key: true
      t.references :ebook, null: false, foreign_key: { to_table: :bx_block_bulk_uploading_ebooks }
      t.date :alloted_date
    end
  end
end
