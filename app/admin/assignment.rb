ActiveAdmin.register BxBlockCatalogue::Assignment, as: "Assignment" do
  menu false
  permit_params :id, :title, :subject_id, :description, :subject_management_id, :assignment, :school_class_id, :school_id, :class_division_id, :account_id

  action_item :back, only: [:new, :show, :edit] do
    subject_id = resource&.subject_management_id || params[:subject_management_id]
    link_to 'Back ', admin_subject_and_teacher_path(subject_id), class: 'button'
  end

  controller do 
    def destroy
      subject = resource&.subject_management_id
      resource.destroy
      redirect_to admin_subject_and_teacher_path(subject), notice: 'This assignment is delete successfully.'
    end

    def create
      create! do |format|
        if resource.valid?
          redirect_to admin_subject_and_teacher_path(resource&.subject_management_id), notice: "Assignment created successfully." and return
        else
          handle_assignment_errors
          redirect_to new_admin_assignment_path(
            subject_id: params[:assignment][:subject_id],
            subject_management_id: params[:assignment][:subject_management_id],
            class_division_id: params[:assignment][:class_division_id],
            account_id: params[:assignment][:account_id],
            format: :html
          ) and return
        end
      end
    end

    def update
      update! do |format|
        if resource.valid?
          if params[:assignment][:assignment].blank?
            resource.errors.add(:assignment, "can't be blank")
            render :edit, location: edit_admin_assignment_path(subject_id: params[:assignment][:subject_id], subject_management_id: params[:assignment][:subject_management_id], class_division_id: params[:assignment][:class_division_id], account_id: params[:assignment][:account_id])
            return
          end
            redirect_to admin_subject_and_teacher_path(resource&.subject_management_id), notice: "Assignment updated successfully." and return
        else
          render :edit, location: edit_admin_assignment_path(subject_id: params[:assignment][:subject_id], subject_management_id: params[:assignment][:subject_management_id], class_division_id: params[:assignment][:class_division_id], account_id: params[:assignment][:account_id])
          return
        end
      end
    end

    private

    def handle_assignment_errors
      if resource.errors.include?(:assignment)
        flash[:error] = resource.errors[:assignment].join(', ')
      else
        flash[:error] = 'Please enter data in mandatory fields'
      end
    end
  end

  index do
    selectable_column
    id_column
    column :title
    column :subject_id do |assign| 
      BxBlockCatalogue::Subject.find(assign.subject_id).subject_name rescue nil
    end
    column :description 
    column :assignment do |assign|
      if assign.assignment.attached?
        link_to("View", rails_blob_path(assign.assignment, disposition: "attachment"))
      else
        "No PDF attached"
      end
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

      f.input :assignment, label: 'Add Assignment ', as: :file, input_html: { direct_upload: true }

      if f.object.new_record?
        f.input :subject_management_id, as: :hidden, input_html: { value: params[:subject_management_id] }
        f.input :class_division_id, as: :hidden, input_html: { value: params[:class_division_id] }
        f.input :school_class_id, as: :hidden, input_html: { value: params[:school_class_id] }
        f.input :school_id, as: :hidden, input_html: { value: params[:school_id] }
        f.input :account_id, as: :hidden, input_html: { value: params[:account_id] }
      else
        f.input :subject_management_id, as: :hidden, input_html: { value: f.object.subject_management_id }
        f.input :class_division_id, as: :hidden, input_html: { value: f.object.class_division_id }
        f.input :school_class_id, as: :hidden, input_html: { value: f.object.school_class_id }
        f.input :school_id, as: :hidden, input_html: { value: f.object.school_id }
        f.input :account_id, as: :hidden, input_html: { value: f.object.account_id }
      end
    end
    f.actions do
      if resource.persisted?
        f.action :submit, as: :button, label: 'Update  Assignment'
        f.action :cancel
      else
        f.action :submit, label: "Create Assignment"
        f.action :cancel
      end
    end
  end

  show do
    attributes_table do
      row :id
      row :title
      row :subject_id do |assign| 
        BxBlockCatalogue::Subject.find(assign.subject_id).subject_name rescue nil
      end
      row :description
      row :assignment do |assign|
        if assign.assignment.attached?
          link_to("View ", rails_blob_path(assign.assignment, disposition: "attachment"))
        else
          "No PDF attached"
        end
      end
    end
  end

end

