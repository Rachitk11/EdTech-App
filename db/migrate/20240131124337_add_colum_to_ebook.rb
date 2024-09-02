class AddColumToEbook < ActiveRecord::Migration[6.0]
  def change
    add_column :ebook_allotments, :download, :boolean, default: false
    add_column :ebook_allotments, :downloaded_date, :date
    add_column :ebook_allotments, :status, :string
    add_column :ebook_allotments, :completed, :boolean, default: false
  end
end
