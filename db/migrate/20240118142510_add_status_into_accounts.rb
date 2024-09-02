class AddStatusIntoAccounts < ActiveRecord::Migration[6.0]
  def change
  	add_column :accounts, :video_status, :boolean , default: false 
  	add_column :accounts, :assignment_status, :boolean , default: false 
  	add_column :accounts, :assignment_download, :boolean , default: false 
  end
end
