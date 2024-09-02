ActiveAdmin.register AccountBlock::Account, as: "Teachers" do
  menu false
  actions :all
  permit_params :first_name, :last_name, :email, :full_phone_number, :user_type, :teacher_unique_id, :role_id, :school_id, :department, :class_division_id, :school_class_id
  filter :email

  action_item :back, only: [:new, :show, :edit] do
    if params[:id].present?
      link_to 'Back', admin_school_url(AccountBlock::Account.find(params[:id]).school)
    else
      link_to 'Back', admin_school_url(params[:school_id])
    end
  end

  controller do
    def scoped_collection
      if current_admin_user.super_admin?
        AccountBlock::Account.joins(:role).where(roles: {name: "Teacher"})
      else
        AccountBlock::Account.joins(:role).where(roles: { name: "Teacher" }).where(school_id: current_admin_user.school_id)
      end
    end
    def destroy
      teacher = AccountBlock::Account.find(params[:id])
      school = teacher.school
      teacher.delete
      redirect_to admin_school_url(school)
    end

    after_create do |account|
      profile = BxBlockProfile::Profile.new(account_id: account.id)
      profile.user_name = account.first_name
      profile.email = account.email
      profile.full_phone_number = account.full_phone_number
      profile.teacher_unique_id = account.teacher_unique_id
      profile.save
    end

    def create
      create! do |format|
        if resource.errors.present?
          redirect_to new_admin_teacher_path(school_id: params[:account][:school_id], format: :html), notice: "Teacher email id must be unique" and return
        else
          redirect_to admin_school_path(resource.school_id), notice: "Teacher created successfully." and return
        end
      end
    end

    def update
      update! do |format|
        if resource.errors.present?
          render :edit, location: edit_admin_teacher_path(school_id: params[:account][:school_id])
          return
        else
          redirect_to admin_school_path(resource.school_id), notice: "Teacher updated successfully." and return
        end
      end
    end
  end

  index do
    id_column
    column :name do |teacher|
      teacher.first_name
    end
    column :email
    column :phone_number do |teacher|
      teacher.full_phone_number
    end
    column :role  do |teacher|
      teacher.role&.name
    end
    column :school do |teacher|
      teacher.school&.name
    end
    column :teacher_unique_code do |teacher|
      teacher.teacher_unique_id
    end
    column :department
    actions
  end

  show do |cs|
    attributes_table do
      row :name do |teacher|
        teacher.first_name
      end
      row :email
      row :phone_number do |teacher|
        teacher.full_phone_number
      end
      row :role do |teacher|
        teacher.role&.name
      end
      row :school do |teacher|
        teacher.school&.name
      end
      row :teacher_unique_code do |teacher|
        teacher.teacher_unique_id
      end
      row :department
    end
  end

  form do |f|
    f.inputs do
      f.input :role_id, as: :select, collection: BxBlockRolesPermissions::Role.where(name: "Teacher"), include_blank: false
      # f.input :school_id, as: :select, collection: BxBlockCategories::School.where(id: params[:school_id].to_i), include_blank: false
      school_collection = if f.object && !f.object.new_record?
                            BxBlockCategories::School.where(id: f.object.school_id)
                          else
                            BxBlockCategories::School.where(id: params[:school_id].to_i)
                          end
      f.input :school_id, as: :select, collection: school_collection, include_blank: false
      f.input :first_name, label: "Name", required: true
      if !f.id.nil?
        f.input :email, required: true, input_html: {readonly: true}
      end
      f.input :email, required: true
      f.input :teacher_unique_id, label: "Teacher Unique code", required: true
      f.input :full_phone_number, label: "Phone Number", required: true
      f.input :department
    end
    f.actions do
      f.action :submit, label: "Save"
    end
  end
end
