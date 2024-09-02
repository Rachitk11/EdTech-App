class DeleteAllRoles < ActiveRecord::Migration[6.0]
  def change
  	BxBlockRolesPermissions::Role.delete_all
  end
end
