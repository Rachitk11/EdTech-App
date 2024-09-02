class CreateEbooks < ActiveRecord::Migration[6.0]
  def change
    create_table :bx_block_bulk_uploading_ebooks do |t|
    	t.string :title
      t.string :author
      t.string :size
      t.integer :pages
      t.string :edition
      t.string :publisher
      t.date :publication_date
      t.string :formats_available
      t.string :language
      t.text :description
      t.decimal :price

      t.timestamps
    end
  end
end