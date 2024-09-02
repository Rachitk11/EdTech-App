ActiveAdmin.register BxBlockCategories::ClassDivision, as: "ClassDivision" do
  menu false
  
  permit_params :id, :division_name, :school_id, :school_class_id, :account_id, subject_ids: [], subject_teacher_ids: []

  action_item :back, only: :show do
    link_to 'Back to Class', admin_class_path(resource.school_class_id), class: 'button'
  end

  after_create do |class_division|
    class_division.account.update(class_division_id: class_division.id)
  end

  controller do 
    def destroy
      school_class_id = resource.school_class_id
      AccountBlock::Account.where(role_id: BxBlockRolesPermissions::Role.find_by(name: 'Student').id,class_division_id: resource.id).delete_all
      resource.subject_teacher_ids.each do |account|
        account = AccountBlock::Account.find_by(id: account)
        account.subject_teacher_division_ids = account.subject_teacher_division_ids - [resource.id]
        # account.subject_teacher_class_ids = account.subject_teacher_class_ids - [resource.school_class.id]
        account.save
      end
      AccountBlock::Account.where(role_id: BxBlockRolesPermissions::Role.find_by(name: 'Teacher').id,class_division_id: resource.id).update(class_division_id: nil, school_class_id: nil)
      resource.destroy
      redirect_to admin_class_path(school_class_id), notice: "Class Division deleted successfully."
    end

    def update
      subject_ids = resource.subject_ids || []
      subject_ids += [params[:class_division][:subject_ids]]
      subject_teacher_ids = resource.subject_teacher_ids || []
      subject_teacher_ids += [params[:class_division][:subject_teacher_ids]]
      subject_ids = subject_ids.uniq
      subject_teacher_ids = subject_teacher_ids.uniq
      resource.update(subject_ids: subject_ids, subject_teacher_ids: subject_teacher_ids)
      subject_management = resource.subject_managements.find_or_create_by!(subject_id: params[:class_division][:subject_ids], account_id: params[:class_division][:subject_teacher_ids])
      account = AccountBlock::Account.find_by(id: subject_management.account_id)
      account_subject_id = account.subject_ids || []
      account_subject_id += [params[:class_division][:subject_ids]]
      subject_management_ids = account.subject_management_ids || []
      subject_management_ids += [subject_management.id]
      subject_teacher_division_ids = account.subject_teacher_division_ids || []
      subject_teacher_division_ids += [subject_management.class_division_id]
      school_class =  subject_management.class_division.school_class_id
      subject_teacher_class_ids = account.subject_teacher_class_ids || []
      subject_teacher_class_ids += [school_class]
      account.update(subject_ids: account_subject_id.uniq, subject_management_ids: subject_management_ids.uniq, subject_teacher_division_ids: subject_teacher_division_ids.uniq, subject_teacher_class_ids: subject_teacher_class_ids.uniq)
      redirect_to admin_class_division_path(resource), notice: 'Subject and teacher updated successfully.'
    end
  end

  index do
    id_column
    column :division_name
    actions
  end

  show title: "Class Division" do |cs|
    attributes_table do
      row "Class" do
        "#{cs.school_class.class_number} #{cs.division_name}"
      end

      row 'Add Subject and Teacher' do
        form_for(resource, url: admin_class_division_path(resource), method: :patch, html: { multipart: true }) do |f|
          panel 'Subject' do
            selected_subject_ids = resource.subject_ids || []
            available_subjects = BxBlockCatalogue::Subject.where.not(id: selected_subject_ids)
            f.select :subject_ids, options_for_select(available_subjects.pluck(:subject_name, :id), selected: selected_subject_ids)
          end

          panel 'Subject Teacher' do
            # selected_teacher_ids = resource.subject_teacher_ids || []
            available_teachers = AccountBlock::Account.where(role_id: BxBlockRolesPermissions::Role.find_by(name: "Teacher")).where(school_id: resource&.school_id)#.where.not(id: selected_teacher_ids)
            f.select :subject_teacher_ids, options_for_select(available_teachers.pluck(:email, :id),)
          end

          f.submit 'Update'
        end
      end
      subject_and_teacher = resource&.subject_managements
      render "/admin/subject_and_teacher/index", locals: { subject_and_teacher: subject_and_teacher }, layout: "active_admin"


      panel "Students in class #{class_division.school_class.class_number} #{class_division.division_name}" do
        panel link_to 'Add New Student', new_admin_student_url(class_division_id: class_division.id, school_class_id: class_division.school_class_id, school_id: class_division.school_id) do 
        end
        students = AccountBlock::Account.joins(:role).where(roles: { name: "Student" }).where(class_division_id: class_division.id)
        render "/admin/student/index", locals: { students: students }, layout: "active_admin"
      end
    end
  end

  form do |f|
  f.inputs do
      f.input :division_name
      class_collection = if f.object.new_record?
                            BxBlockCategories::SchoolClass.where(id: params[:school_class_id].to_i)
                          else
                            BxBlockCategories::SchoolClass.where(id: f.object.school_class_id)
                          end
      f.input :school_class_id, as: :select, collection: class_collection.pluck(:class_number, :id), include_blank: false
      account_collection = if f.object.persisted?
                              AccountBlock::Account.where(role_id: BxBlockRolesPermissions::Role.find_by(name: "Teacher"), class_division_id: f.object.id).pluck(:email, :id)
                            else
                              AccountBlock::Account.where(role_id: BxBlockRolesPermissions::Role.find_by(name: "Teacher"), school_id: params[:school_id], school_class_id: params[:id], class_division_id: nil).pluck(:email, :id)
                            end
      f.input :account_id, label: "Class Teacher", as: :select, collection: account_collection, include_blank: false
    end
    f.actions do
      if resource.persisted?
        f.action :submit, as: :button, label: 'Update Class Division'
        f.action :cancel#, as: :button, label: 'Cancel' ,wrapper_html: { onclick: "window.location.href = '#{admin_class_division_path(params[:id])}'" }
      else
        f.actions
      end
    end
  end
end

