module AdminUsers
    class Load
      @@loaded_from_gem = false
      def self.is_loaded_from_gem
        @@loaded_from_gem
      end
  
      # def self.loaded
      # end
  
      # Check if this file is loaded from gem directory or not
      # The gem directory looks like
      # /template-app/.gems/gems/bx_block_custom_user_subs-0.0.7/app/admin/subscription.rb
      # if it has block's name in it then it's a gem
      @@loaded_from_gem = Load.method('loaded').source_location.first.include?('bx_block_')
    end
  end
  
  unless AdminUsers::Load.is_loaded_from_gem
    ActiveAdmin.register AdminUser, as: "SubAdminUser" do
      menu label: "Edit Permission" 
      permit_params :email, :role, :school_id, :password, :password_confirmation, :school_allow, :class_allow, :subject_allow, :assignment_allow, :video_allow, :account_allow
    
      index do
        selectable_column
        id_column
        column :email
        column :school_id
        column :school_name do |resource|
          school = BxBlockCategories::School.find_by(id: resource.school_id)
          school.name if school
        end
        column :role
        column :current_sign_in_at
        column :sign_in_count
        column :created_at
        actions
      end

      show do
        attributes_table do
          row :email
          row :role
          row :school_allow
          row :class_allow
          row :subject_allow
          row :assignment_allow
          row :video_allow
          row :account_allow
          row :created_at
          row :updated_at
        end
      end
    
      filter :email
      filter :school_id, as: :select, collection: proc { BxBlockCategories::School.pluck(:name, :id) }

      filter :current_sign_in_at
      filter :sign_in_count
      filter :created_at
    
      before_build do |admin_user|
        admin_user.role ||= :sub_admin
      end
    
      form do |f|
        f.inputs do
          f.input :role, as: :hidden 
          school_id = params[:school_id] || f.object.school_id
          school_name = BxBlockCategories::School.find_by(id: school_id)&.name
          f.input :school_id, input_html: { value: school_id, readonly: true }, as: :hidden 
          f.input :school_name, input_html: { value: school_name, readonly: true }
         
         
          f.input :email, input_html: { value: params[:email] || f.object.email, readonly: true  } 
          # f.input :school_id, input_html: { value: f.object.school_id, readonly: true } 
          # f.input :email, input_html: { value: f.object.email, readonly: true }
    
          f.input :password
          f.input :password_confirmation
          
          f.input :school_allow, as: :boolean
          f.input :class_allow, as: :boolean
          f.input :subject_allow, as: :boolean
          f.input :assignment_allow, as: :boolean
          f.input :video_allow, as: :boolean
          f.input :account_allow, as: :boolean
        end
        f.actions
      end

      controller do
        def scoped_collection
          AdminUser.where(role: :sub_admin)
        end
      end
    end  
  end