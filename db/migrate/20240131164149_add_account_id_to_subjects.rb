class AddAccountIdToSubjects < ActiveRecord::Migration[6.0]
  def change
  	add_column :subjects, :account_id, :integer
  end
end
