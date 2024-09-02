ActiveAdmin.register BxBlockCatalogue::VideosLecture, as: "Video Lecture" do
  menu false
  permit_params :id, :video, :title, :subject, :description, :subject_id, :subject_management_id, :class_division_id, :school_id, :school_class_id, :account_id, :time_hour, :time_min

  action_item :back, only: [:new, :show, :edit] do
    @subject_management_id = resource&.subject_management_id || params[:subject_management_id]
    link_to 'Back', admin_subject_and_teacher_path(@subject_management_id), class: 'button'
  end

  controller do 
    def destroy
      @subject_management_id = resource&.subject_management_id
      resource.destroy
      redirect_to admin_subject_and_teacher_path(@subject_management_id), notice: "This video lecture is delete successfully."
    end

    def create
      create! do |format|
        if resource.valid?
          redirect_to admin_subject_and_teacher_path(resource&.subject_management_id), notice: "Video Lecture created successfully." and return
        else
          handle_video_errors
          redirect_to new_admin_video_lecture_path(subject_id: params[:videos_lecture][:subject_id], subject_management_id: params[:videos_lecture][:subject_management_id], class_division_id: params[:videos_lecture][:class_division_id], account_id: params[:videos_lecture][:account_id], format: :html) and return
        end
      end
    end

    def update
      update! do |format|
        if resource.errors.present?
          render :edit, location: edit_admin_video_lecture_path(subject_id: params[:videos_lecture][:subject_id], subject_management_id: params[:videos_lecture][:subject_management_id], class_division_id: params[:videos_lecture][:class_division_id], account_id: params[:videos_lecture][:account_id])
          return
        else
          redirect_to admin_subject_and_teacher_path(resource&.subject_management_id), notice: "Video Lecture updated successfully." and return
        end
      end
    end

    private

    def handle_video_errors
      if resource.errors.include?(:video)
        flash[:error] = resource.errors[:video].join(', ')
      else
        flash[:error] = 'Please enter data in mandatory fields'
      end
    end

  end

  index do
    selectable_column
    id_column
    column :title
    column :subject_id do |video| 
      BxBlockCatalogue::Subject.find(video.subject_id).subject_name rescue nil
    end
    column :description
    column :video do |resource|
      link_to resource.video, resource.video, target: '_blank'
    end 
    actions
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :title
      subject = if f.object.new_record?
                  BxBlockCatalogue::Subject.where(id: params[:subject_id].to_i)
                else
                  BxBlockCatalogue::Subject.where(id: f.object.subject_id)
                end
      f.input :subject_id, as: :select, collection: subject.pluck(:subject_name, :id), include_blank: false
      f.input :description

      if f.object.new_record?
        f.input :video
        f.input :time_hour, as: :select, collection: 0..23
        f.input :time_min, as: :select, collection: 0..59
        f.input :subject_management_id, as: :hidden, input_html: { value: params[:subject_management_id] }
        f.input :class_division_id, as: :hidden, input_html: { value: params[:class_division_id] }
        f.input :school_class_id, as: :hidden, input_html: { value: params[:school_class_id] }
        f.input :school_id, as: :hidden, input_html: { value: params[:school_id] }
        f.input :account_id, as: :hidden, input_html: { value: params[:account_id] }
      else
        f.input :video do
          link_to 'Watch Video', f.object.video, target: '_blank'
        end
        f.input :time_hour, as: :select, collection: 0..23, input_html: { value: f.object.time_hour }
        f.input :time_min, as: :select, collection: 0..59, input_html: { value: f.object.time_min }
        f.input :subject_management_id, as: :hidden, input_html: { value: f.object.subject_management_id }
        f.input :class_division_id, as: :hidden, input_html: { value: f.object.class_division_id }
        f.input :school_class_id, as: :hidden, input_html: { value: f.object.school_class_id }
        f.input :school_id, as: :hidden, input_html: { value: f.object.school_id }
        f.input :account_id, as: :hidden, input_html: { value: f.object.account_id }
      end
    end
    f.actions do
      if resource.persisted?
        f.action :submit, as: :button, label: 'Update  Videos Lecture'
        f.action :cancel
      else
        f.action :submit, label: "Create Videos Lecture"
        f.action :cancel
      end
    end
  end

  show do
    attributes_table do
      row :id
      row :title
      row :subject_id do |video| 
        BxBlockCatalogue::Subject.find(video.subject_id).subject_name rescue nil
      end
      row :description
      row :video do |resource|
        link_to resource.video, resource.video, target: '_blank'
      end 
      row :time_hour
      row :time_min
    end
  end

end