class CreateRemoveBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :remove_books do |t|
      t.references :account, foreign_key: { to_table: 'accounts' }
      t.references :ebook, foreign_key: { to_table: 'bx_block_bulk_uploading_ebooks' }
      t.timestamps
    end
  end
end
