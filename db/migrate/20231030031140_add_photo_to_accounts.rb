class AddPhotoToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :photo, :string
  end
end
