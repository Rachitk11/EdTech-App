class AddSchoolIdToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :school_id, :integer
  end
end
