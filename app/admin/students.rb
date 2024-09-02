ActiveAdmin.register AccountBlock::Account, as: "Students" do
  menu false
  actions :all

  permit_params :first_name, :last_name, :full_phone_number, :user_type, :guardian_email, :role_id, :school_id, :student_unique_id, :class_division_id, :school_class_id
  filter :guardian_email

  action_item :back, only: [:new, :show, :edit] do
    if resource&.class_division_id.present?
      link_to 'Back', admin_class_division_path(resource.class_division_id)
    else params[:class_division_id]&.present?
      link_to 'Back', admin_class_division_path(params[:class_division_id])
    end
  end

  controller do 
    # def scoped_collection
    #   AccountBlock::Account.joins(:role).where(roles: {name: "Student"})
    # end

    def scoped_collection
      if current_admin_user.super_admin?
        AccountBlock::Account.joins(:role).where(roles: { name: "Student" })
      else
        AccountBlock::Account.joins(:role).where(roles: { name: "Student" }).where(school_id: current_admin_user.school_id)
      end
    end

    def destroy
      student = AccountBlock::Account.find(params[:id])
      student.delete
      redirect_to admin_class_division_path(student.class_division_id), notice: "Student deleted successfully."
    end

    after_create do |account|
      profile = BxBlockProfile::Profile.new(account_id: account.id)
      profile.user_name = account.first_name
      profile.guardian_contact_no = account.full_phone_number
      profile.student_unique_id = account.student_unique_id
      profile.guardian_email = account.guardian_email
      profile.save
    end

    def create
      create! do |format|
        if resource.errors.present?
          class_division_id = params[:account]&.dig(:class_division_id) || resource.class_division_id
          redirect_to new_admin_student_path(class_division_id: class_division_id, school_class_id: params[:account][:school_class_id], school_id: params[:account][:school_id], format: :html), notice: "Student Id must be unique" and return
        else
          redirect_to admin_class_division_path(resource.class_division_id), notice: "Student created successfully." and return
        end
      end
    end

    def update
      update! do |format|
        if resource.errors.present?
          render :edit, location: edit_admin_student_path(class_division_id: params[:account][:class_division_id], school_class_id: params[:account][:school_class_id], school_id: params[:account][:school_id])
          return
        else
          redirect_to admin_class_division_path(resource.class_division_id), notice: "Student updated successfully." and return
        end
      end
    end
  end

  index do
    id_column
    column :name do |student|
      student.first_name
    end
    column :guardian_email
    column :phone_number do |student|
      student.full_phone_number
    end
    column :role  do |student|
      student.role&.name
    end
    column :student_unique_code do |student|
      student.student_unique_id
    end

    column :school do |student|
      student.school&.name
    end
    actions
  end

  show do |cs|
    attributes_table do
      row :name do |student|
        student.first_name
      end
      row :guardian_email
      row :phone_number do |student|
        student.full_phone_number
      end
      row :role do |student|
        student.role&.name
      end

      row :student_unique_code do |student|
        student.student_unique_id
      end

      row :school do |student|
        student.school&.name
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :role_id, as: :select, collection: BxBlockRolesPermissions::Role.where(name: "Student"), include_blank: false
      # f.input :school_id, as: :select, collection: BxBlockCategories::School.all, include_blank: false
      school_collection = if f.object && !f.object.new_record?
                            BxBlockCategories::School.where(id: f.object.school_id)
                          else
                            BxBlockCategories::School.where(id: params[:school_id].to_i)
                          end
      f.input :school_id, as: :select, collection: school_collection, include_blank: false
      class_collection = if f.object.new_record?
                                  BxBlockCategories::SchoolClass.where(id: params[:school_class_id]).pluck(:class_number, :id)
                                else f.object.school_class_id.blank?
                                  BxBlockCategories::SchoolClass.where(id: f.object.school_class_id).pluck(:class_number, :id)
                                end
      f.input :school_class_id, as: :select, label: "Class", collection: class_collection, include_blank: false
      class_division_collection = if f.object.new_record?
                                  BxBlockCategories::ClassDivision.where(id: params[:class_division_id]).pluck(:division_name, :id)
                                else f.object.class_division_id.blank?
                                  BxBlockCategories::ClassDivision.where(id: f.object.class_division_id).pluck(:division_name, :id)
                                end
      f.input :class_division_id, as: :select, collection: class_division_collection, include_blank: false
        f.input :first_name, label: "Name", required: true
        f.input :student_unique_id, label: "Student Unique Code", required: true
        if !f.id.nil?
          f.input :guardian_email, required: true, input_html: {readonly: true}
        end
        f.input :guardian_email, required: true
        f.input :full_phone_number, label: "Phone Number", required: true
      end
    f.actions do
      f.action :submit, label: "Save"
    end
  end
end
