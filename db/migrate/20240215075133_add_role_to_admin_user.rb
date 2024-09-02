class AddRoleToAdminUser < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_users, :role, :integer
  	add_column :admin_users, :school_id, :integer , default: nil
  end
end
