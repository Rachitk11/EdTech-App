ActiveAdmin.register  BxBlockRolesPermissions::Role, as: "Role" do
  actions :index, :show

  permit_params :name
  filter :name

  controller do
    def destroy
      role = BxBlockRolesPermissions::Role.find(params[:id])
      role.delete
      redirect_to :admin_roles
    end
  end
  
  index do
    id_column
    column :name
  end

  show do |role|
    attributes_table do
      row :name
    end
  end

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end
end
