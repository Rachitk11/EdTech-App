ActiveAdmin.register BxBlockCatalogue::SubjectManagement, as: "Subject And Teacher" do
  menu false
  actions :all, except: [:edit]
  permit_params :id, :subject_id, :account_id , :class_division_id, :school_class_id, :school_id

  action_item :back, only: :show do
    link_to 'Back to Class Division', admin_class_division_path(resource&.class_division_id), class: 'button'
  end


  controller do 
    def destroy
      resource.class_division&.subject_ids = resource&.class_division&.subject_ids - [resource&.subject_id]
      resource.account&.subject_teacher_division_ids = resource.account&.subject_teacher_division_ids - [resource.class_division&.school_class.id]
      resource.account&.subject_teacher_class_ids = resource.account&.subject_teacher_class_ids - [resource&.class_division_id]
      resource.account&.save
      resource&.class_division&.save
      class_division_id = resource&.class_division_id
      resource.destroy
      redirect_to admin_class_division_path(class_division_id), notice: "Subject  deleted  from class successfully."
    end
  end

  index do
    selectable_column
    id_column
    column "Subject" do |subj| 
      subj.subject.subject_name rescue nil
    end
    column "Teacher" do  |tech|
      tech.account.email rescue nil
    end
    actions
  end

  # form do |f|
  #   f.semantic_errors(*f.object.errors.keys)
  #   f.inputs do
  #     selected_subject_ids = resource.subject_ids || []
  #     available_subjects = BxBlockCatalogue::Subject.where.not(id: selected_subject_ids)
  #     f.input :subject_id, as: :select, label: "Subject", collection: available_subjects.pluck(:subject_name, :id), selected: selected_subject_ids
      
  #     selected_teacher_ids = resource.subject_teacher_ids || []
  #     available_teachers = AccountBlock::Account.where(role_id: BxBlockRolesPermissions::Role.find_by(name: "Teacher")).where.not(id: selected_teacher_ids)
  #     f.input :account_id, as: :select, label: "Subject Teacher", collection: available_teachers.pluck(:email, :id), selected: selected_teacher_ids
      
  #   end
  #     f.actions
  # end

  show title: "Subject" do
    attributes_table do
      row :id
      row "Subject" do
        resource.subject.subject_name rescue nil
      end
      row "Teacher" do
        resource.account.email rescue nil
      end

      panel "Video Lecture" do
        panel link_to 'Add Video Lecture',  new_admin_video_lecture_url(subject_id: resource.subject_id, subject_management_id: resource&.id, school_class_id: resource&.class_division.school_class_id, school_id: resource&.class_division.school_id, class_division_id: resource&.class_division_id, account_id: resource&.account_id) do 
        videos = BxBlockCatalogue::VideosLecture.where(subject_management_id: resource.id)
        render "/admin/subject_and_teacher/video", locals: { videos: videos }, layout: "active_admin"
        end
      end

      panel "Assigment" do
        panel link_to 'Add Assigment',  new_admin_assignment_url(subject_id: resource.subject_id, subject_management_id: resource&.id, school_class_id: resource&.class_division.school_class_id, school_id: resource&.class_division.school_id, class_division_id: resource&.class_division_id, account_id: resource&.account_id) do 
        assignments = BxBlockCatalogue::Assignment.where(subject_management_id: resource.id)
        render "/admin/subject_and_teacher/assignment", locals: { assignments: assignments }, layout: "active_admin"
        end
      end
    end
  end

end