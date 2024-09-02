class RemoveSchoolUniqueCodeFromAccounts < ActiveRecord::Migration[6.0]
  def change
    remove_column :accounts, :student_unique_code, :string
  end
end
