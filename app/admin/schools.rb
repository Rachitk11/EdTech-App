ActiveAdmin.register  BxBlockCategories::School, as: "Schools" do

  actions :all

  permit_params :name, :email, :board, :phone_number, :principal_name
  filter :email

  index do
    id_column
    column :name
    column :email
    column :principal_name
    column :phone_number
    column :board
    actions
  end

  show do |cs|
    attributes_table do
      row :name
      row :email
      row :principal_name
      row :phone_number
      row :board
    end

    panel "Classes" do
      panel link_to 'New School Class', new_admin_class_url(school_id: params[:id]) do 
      end
      school_classes = BxBlockCategories::SchoolClass.where(school_id: params[:id])
      render "/admin/school_class/index" , :locals => {school_classes: school_classes}, layout: "active_admin"
    end

    panel "School Admins" do
      panel link_to 'New School Admin', new_admin_school_admin_url(school_id: params[:id]) do
      end
      school_admins = AccountBlock::Account.joins(:role).where(roles: {name: "School Admin"}).where(school_id: params[:id])
      render "/admin/school_admin/index", :locals => {school_admins: school_admins}, layout: "active_admin"
    end

    panel "Teachers" do
      panel link_to 'New Teacher', new_admin_teacher_url(school_id: params[:id]) do
      end
      teachers = AccountBlock::Account.joins(:role).where(roles: {name: "Teacher"}).where(school_id: params[:id])
      render "/admin/teacher/index", :locals => {teachers: teachers}, layout: "active_admin"
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :principal_name
      f.input :phone_number
      f.input :board
    end
    f.actions
  end

  controller do
    def destroy
      resource.school_classes.flat_map(&:class_divisions).each do |div|
        AccountBlock::Account.where(role_id: BxBlockRolesPermissions::Role.find_by(name: 'Student').id, class_division_id: div&.id).delete_all
      end
      AccountBlock::Account.where(role_id: BxBlockRolesPermissions::Role.find_by(name: 'Teacher').id, school_id: resource&.id).delete_all
      # resource.school_classes&.flat_map(&:class_divisions)&.delete_all
      class_divisions = resource.school_classes&.flat_map(&:class_divisions)
      class_divisions&.each(&:destroy) if class_divisions.present?
      resource.school_classes&.delete_all
      resource.accounts.where(role_id: BxBlockRolesPermissions::Role.find_by(name: "School Admin")).delete_all
      resource.destroy
      redirect_to admin_schools_path, notice: "School deleted successfully."
    end

  end
end
