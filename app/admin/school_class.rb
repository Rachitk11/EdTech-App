ActiveAdmin.register BxBlockCategories::SchoolClass, as: "Class" do
  menu false

  permit_params :id, :class_number, :school_id, :account_id, class_divisions_attributes: [:id, :division_name, :account_id]

  action_item :back, only: [:new, :show, :edit] do
    school_id = resource&.school_id || params[:school_id]
    if school_id
      link_to 'Back to School View', admin_school_path(school_id), class: 'button'
    else
      link_to 'Back to School View', admin_schools_path, class: 'button'
    end
  end

  after_save do |school_class|
    school_class.class_divisions.each do |division|
      division.update(school_id: school_class.school_id)
      AccountBlock::Account.find_by(id: division.account_id)&.update(class_division_id: division.id, school_class_id: school_class.id)
    end
  end

  controller do 
    def destroy
      school_id = resource.school_id
      resource.class_divisions&.each do |divi|
        AccountBlock::Account.where(role_id: BxBlockRolesPermissions::Role.find_by(name: 'Student').id, class_division_id: divi.id).delete_all
        divi.subject_teacher_ids.each do |account|
          account = AccountBlock::Account.find_by(id: account)
          account.subject_teacher_division_ids = account.subject_teacher_division_ids - [divi.id]
          account.subject_teacher_class_ids = account.subject_teacher_class_ids - [resource.id]
          account.save
        end
      end
      resource.class_divisions.delete_all
      AccountBlock::Account.where(role_id: BxBlockRolesPermissions::Role.find_by(name: 'Teacher').id, school_class_id: resource&.id)&.update(school_class_id: nil, class_division_id: nil)
      resource.destroy
      redirect_to admin_school_path(school_id), notice: "Class deleted successfully."
    end

    def create
      divisions_params = params[:school_class][:class_divisions_attributes]&.values
      division_names = divisions_params&.map { |division| division[:division_name] }
      division_teacher_accounts = divisions_params&.map { |division| division[:account_id] }
      if params["school_class"]["class_number"].present? && division_names&.uniq&.length.to_i < division_names&.length.to_i
        flash[:error] = 'Division name must be unique within the class.'
        redirect_to new_admin_class_path
        return
      elsif params["school_class"]["class_number"].present? && division_teacher_accounts&.uniq&.length.to_i < division_teacher_accounts&.length.to_i
          flash[:error] = 'Class Teacher must be unique within the class division of class.'
        redirect_to new_admin_class_path
        return
      end
      super
    end

    def update
      divisions_params = params[:school_class][:class_divisions_attributes]&.values
      division_names = divisions_params&.map { |division| division[:division_name] }
      division_teacher_accounts = divisions_params&.map { |division| division[:account_id] }
      if params["school_class"]["class_number"].present? && division_names&.uniq&.length.to_i < division_names&.length.to_i
        flash[:error] = 'Division name must be unique within the class.'
        redirect_to edit_admin_class_path
        return
      elsif params["school_class"]["class_number"].present? && division_teacher_accounts&.uniq&.length.to_i < division_teacher_accounts&.length.to_i
          flash[:error] = 'Class Teacher must be unique within the class division of class.'
        redirect_to edit_admin_class_path
        return
      end
      super
    end
  end

  index do
    id_column
    column :class_number
    column :school_id do |cs|
    
      BxBlockCategories::School.find_by(id: cs&.school_id)&.name
    end
    actions
  end

  show title: "Classes" do |cs|
    attributes_table do
      row :school do |cs|
        BxBlockCategories::School.find(cs.school_id).name
      end
      row :class_number
      panel "Class Division" do
        class_divisions = BxBlockCategories::ClassDivision.where(school_class_id: params[:id])
        render "/admin/class_division/index", locals: { class_divisions: class_divisions }, layout: "active_admin"
      end
    end
  end

  form do |f|
    f.inputs do
      if f.object.new_record?
        f.input :class_number, as: :select, collection: 1..12
      else
        f.input :class_number, as: :select, collection: [[f.object.class_number, f.object.class_number]], include_blank: false
      end
      school_collection = if f.object && !f.object.new_record?
                            BxBlockCategories::School.where(id: f.object.school_id)
                          else
                            BxBlockCategories::School.where(id: params[:school_id].to_i)
                          end
      f.input :school_id, as: :select, collection: school_collection, include_blank: false
    end

    f.inputs 'Class Division' do
      f.has_many :class_divisions, heading: 'Add Class Divisions', allow_destroy: true, new_record: 'Add Division' do |division|
        division.input :division_name, required: true
        school = BxBlockCategories::School.find_by(id: f.object.school_id)
        account_collection =  if division.object.persisted?
                                AccountBlock::Account.where(role_id: BxBlockRolesPermissions::Role.find_by(name: "Teacher"), class_division_id: division.object.id).pluck(:email, :id)
                              elsif school
                                AccountBlock::Account.where(role_id: BxBlockRolesPermissions::Role.find_by(name: "Teacher"), school_id: school.id, class_division_id: nil).pluck(:email, :id)
                              else
                                AccountBlock::Account.where(role_id: BxBlockRolesPermissions::Role.find_by(name: "Teacher"), school_id: params[:school_id], school_class_id: params[:id], class_division_id: nil).pluck(:email, :id)
                              end
        division.input :account_id, label: "Class Teacher", as: :select, collection: account_collection, required: true
      end
      f.semantic_errors :base
    end

    f.actions do
      if resource.persisted?
        f.action :submit, as: :button, label: 'Update School Class'
        f.action :cancel
      else
        f.action :submit, label: "Save"
        f.action :cancel
      end
    end
    
  end
end