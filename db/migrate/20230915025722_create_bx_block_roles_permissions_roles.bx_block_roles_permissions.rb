# This migration comes from bx_block_roles_permissions (originally 20200924131101)
class CreateBxBlockRolesPermissionsRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :name
      t.timestamps
    end
  end
end
