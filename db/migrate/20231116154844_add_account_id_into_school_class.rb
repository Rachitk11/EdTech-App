class AddAccountIdIntoSchoolClass < ActiveRecord::Migration[6.0]
  def change
  	add_column :school_classes, :account_id, :integer
  end
end
