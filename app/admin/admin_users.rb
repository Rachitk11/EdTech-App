module AdminUsers
  class Load
    @@loaded_from_gem = false
    def self.is_loaded_from_gem
      @@loaded_from_gem
    end

    def self.loaded
    end

    # Check if this file is loaded from gem directory or not
    # The gem directory looks like
    # /template-app/.gems/gems/bx_block_custom_user_subs-0.0.7/app/admin/subscription.rb
    # if it has block's name in it then it's a gem
    @@loaded_from_gem = Load.method('loaded').source_location.first.include?('bx_block_')
  end
end

unless AdminUsers::Load.is_loaded_from_gem
  ActiveAdmin.register AdminUser do
    permit_params :email, :role, :school_id,  :password, :password_confirmation

    index do
      selectable_column
      id_column
      column :email
      column :current_sign_in_at
      column :sign_in_count
      column :created_at
      actions
    end

    show do
      attributes_table do
        row :email
        row :role
        row :created_at
        row :updated_at
      end
    end

    filter :email
    filter :current_sign_in_at
    filter :sign_in_count
    filter :created_at
   
    before_build do |admin_user|
      admin_user.role ||= :super_admin 
    end
    
    form do |f|
      f.inputs do
        f.input :email
        f.input :password
        f.input :password_confirmation
      end
      f.actions
    end
    controller do
      def scoped_collection
        AdminUser.where(role: :super_admin)
      end
    end
  end
end