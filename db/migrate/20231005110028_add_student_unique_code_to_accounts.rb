class AddStudentUniqueCodeToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :student_unique_code, :string
  end
end
