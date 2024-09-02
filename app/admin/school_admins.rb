ActiveAdmin.register AccountBlock::Account, as: "School Admins" do
  menu false
  actions :all
  permit_params :first_name, :email, :full_phone_number, :role_id, :school_id
  filter :email

  action_item :back,  only: [:show, :edit] do
    link_to "Back", admin_school_url(AccountBlock::Account.find(params[:id]).school)
  end

  controller do
    def scoped_collection
      AccountBlock::Account.joins(:role).where(roles: {name: "School Admin"})
    end

    def destroy
      school_admin = AccountBlock::Account.find(params[:id])
      school = school_admin.school
      school_admin.delete
      redirect_to admin_school_url(school)
    end

    after_create do |account|
      profile = BxBlockProfile::Profile.new(account_id: account.id)
      profile.user_name = account.first_name
      profile.email = account.email
      profile.full_phone_number = account.full_phone_number
      # profile.employee_unique_id = account.employee_unique_id
      profile.save
    end

    def create
      create! do |format|
        if resource.errors.present?
          redirect_to new_admin_school_admin_path(school_id: params[:account][:school_id], format: :html), notice: "School Admin email id must be unique" and return
        else
          redirect_to admin_school_path(resource.school_id), notice: "School Admin created successfully." and return
        end
      end
    end

    def update
      update! do |format|
        if resource.errors.present?
          render :edit, location: edit_admin_school_admin_path(school_id: params[:account][:school_id])
          return
        else
          redirect_to admin_school_path(resource.school_id), notice: "School Admin updated successfully." and return
        end
      end
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

  form do |f|
    f.inputs do
      f.input :role_id, as: :select, collection: BxBlockRolesPermissions::Role.where(name: "School Admin"), include_blank: false
      f.input :school_id, as: :select, collection: BxBlockCategories::School.where(id: params[:school_id].to_i), include_blank: false
      f.input :first_name, label: "Name", required: true
      f.input :full_phone_number, label: "Phone Number", required: true
      if !f.id.nil?
        f.input :email, required: true, input_html: {readonly: true}
      else
        f.input :email, required: true
      end
    end
    f.actions do
      f.action :submit, label: "Save"
    end
  end
end
