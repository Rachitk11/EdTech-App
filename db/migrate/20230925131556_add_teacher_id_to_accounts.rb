class AddTeacherIdToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :teacher_unique_id, :string
  end
end
