ActiveAdmin.register AccountBlock::Account, as: "SchoolAdminsPermission" do
  menu label: "MakePermissions"
  menu if: proc { current_admin_user.super_admin? }
  
    actions :index, :show
    permit_params :first_name, :email, :full_phone_number, :role_id, :school_id
    filter :email
    filter :school

  
    action_item :back, only: [:show, :edit] do
      link_to "Back", admin_school_url(AccountBlock::Account.find(params[:id]).school)
    end
  
     
    # action_item :add_sub_admin, only: [:show, :edit, :create]do
    #   link_to "Add Sub Admin", new_admin_sub_admin_user_path(school_id: resource.school&.id, email: resource.email)
    #   # link_to "Add Sub Admin", new_admin_sub_admin_user_path(school_id: resource.school_id, email: resource.email)
    # end
    action_item :add_sub_admin, only: [:show, :edit, :create] do
      school_id = resource.school_id if resource.school_id.present?
      school_name = resource.school&.name 
      link_to "Add Sub Admin", new_admin_sub_admin_user_path(school_id: school_id, school_name: school_name, email: resource.email)
    end
    
    
   
    controller do
      def scoped_collection
        AccountBlock::Account.joins(:role).where(roles: {name: "School Admin"})
      end
    end
  
    index do
      id_column
      column :name do |school_admin|
        school_admin.first_name
      end
      column :role do |school_admin|
        school_admin.role&.name
      end
      column :school do |school_admin|
        school_admin.school&.name
      end
      column :phone_number do |school_admin|
        school_admin.full_phone_number
      end
      column :email
      actions
    end
  
    show do
      attributes_table do
        row :name do |school_admin|
          school_admin.first_name
        end
        row :role do |school_admin|
          school_admin.role&.name
        end
        row :school do |school_admin|
          school_admin.school&.name
        end
        row :phone_number do |school_admin|
          school_admin.full_phone_number
        end
        row :email
      end
    end
  end
  