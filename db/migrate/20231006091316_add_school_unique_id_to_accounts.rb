class AddSchoolUniqueIdToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :student_unique_id, :string
  end
end
