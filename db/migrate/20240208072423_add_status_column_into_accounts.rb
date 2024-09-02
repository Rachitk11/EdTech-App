class AddStatusColumnIntoAccounts < ActiveRecord::Migration[6.0]
  def change
  	add_column :accounts, :ebook_status, :boolean , default: false 
  	add_column :accounts, :ebook_download, :boolean , default: false
  end
end
