module BxBlockLandingpage2
  class SchoolAdminLandingpagesController < ApplicationController
    before_action :validate_json_web_token, :current_user

    def get_users
      begin
        search_name = params[:search_name]&.downcase
        database_type = params[:database_type]
        class_number = params[:class_number]
        class_division_name = params[:class_division_name]
        filter_subject = params[:filter_subject]

        if current_user.present? && current_user.role.name == "School Admin"
          @school = current_user.school
          @available_classes = fetch_classes
          @class_division = fetch_class_divisions
          @class_array = BxBlockCategories::SchoolClass.where(school_id: @school.id).pluck(:class_number).uniq.sort
          @division_array = BxBlockCategories::ClassDivision.where(school_id: @school.id).pluck(:division_name).uniq.sort
          @subjects_list = all_subjects.pluck(:subject_name)

          selected_class = @available_classes.find { |c| c[:class_number] == class_number.to_i }
          class_id = selected_class[:id] if selected_class.present?
          selected_division = @class_division.find { |d| d[:division_name] == class_division_name }
          class_division_id = selected_division[:id] if selected_division.present?
          @all_students = fetch_accounts("Student", search_name, class_id, class_division_id)
          @total_students_count = @all_students.total_count
          @all_teachers = fetch_accounts("Teacher", search_name, class_id, class_division_id)
          @total_teachers_count = @all_teachers.total_count
          @ebooks = search_ebook(search_name, class_number, filter_subject)#.page(params[:page]).per(params[:per_page])
          @total_ebooks_count = @ebooks.total_count

          render_response(database_type)
        else
          render json: { message: "Invalid User!" }, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: { message: "Internal Server Error: #{e.message}" }, status: :internal_server_error
      end
    end

    def show_student_detail
      content_type = params[:content_type]
      search_name = params[:search_name]&.downcase
      class_number = params[:class_number]
      filter_subject = params[:filter_subject]
      
      if school_admin?
        school = current_user.school
        @account = find_account(params[:id])
        if @account.present?
          @subjects_array = all_subjects
          # subject = BxBlockCatalogue::Subject.find_by(subject_name: filter_subject)
          # subject_id = subject&.id
          # subject_teacher_ids = @account.class_division.subject_teacher_ids
          class_division_id = @account.class_division&.id
          @video_lectures = get_videos(class_division_id, filter_subject).page(params[:page]).per(params[:per_page])
          @total_video_count = @video_lectures.total_count
          @assignments = get_assignments(class_division_id, filter_subject).page(params[:page]).per(params[:per_page])
          @total_assignment_count = @assignments.total_count
          @teachers = find_teachers(class_division_id, filter_subject)
          @total_teacher_count = @teachers.total_count
          @total_ebooks = search_ebook(search_name, class_number, filter_subject).page(params[:page]).per(params[:per_page])
          @total_ebook_count = @total_ebooks.total_count

          render_response_for_student(content_type)
        else
          render json: { message: "User not found" }, status: :not_found
        end
      else
        render_invalid_user_response
      end
    end

    def show_teacher_detail
      type = params[:type]
      search_name = params[:search_name]&.downcase
      class_number = params[:class_number]
      filter_subject = params[:filter_subject]
      begin
        if school_admin?
          school = current_user.school
          @teacher = find_account(params[:id])
          @teacher_allocated = BxBlockCategories::ClassDivision.where(account_id: params[:id] )
          subjects = @teacher&.subject_ids
          @subjects_data = BxBlockCatalogue::SubjectManagement.where(subject_id: subjects, account_id: @teacher&.id).page(params[:page]).per(params[:per_page])
          @total_ebook = search_ebook(search_name, class_number, filter_subject)#.page(params[:page]).per(params[:per_page])
          @ebooks_count = @total_ebook.total_count
          @subjects = all_subjects

          render_response_for_teacher(type)
        else
          render_invalid_user_response
        end
      rescue ActiveRecord::RecordNotFound => e
        render json: { message: "User not found: #{e.message}" }, status: :not_found
      rescue StandardError => e
        render json: { message: "Internal Server Error: #{e.message}" }, status: :internal_server_error
      end
    end

    private

    def render_response(database_type)
      case database_type
      when 'Teacher'
        render json: { teacher_database: serialize_accounts(@all_teachers), teachers_count: @total_teachers_count }
      when 'Student'
        render json: { student_database: serialize_accounts(@all_students), students_count: @total_students_count }
      when 'Publisher'
        render json: { publisher_database: serialize_ebooks(@ebooks), ebooks_count: @total_ebooks_count }
      else
        render json: { student_database: serialize_accounts(@all_students), students_count: @total_students_count, teacher_database: serialize_accounts(@all_teachers), teachers_count: @total_teachers_count, publisher_database: serialize_ebooks(@ebooks), ebooks_count: @total_ebooks_count, class_array: @class_array, division_array: @division_array, subjects_array: @subjects_list }, status: :ok
      end
    end

    def render_response_for_student(content_type)
      case content_type
      when 'Student'
        render json: { student: serialize_account(@account) }, status: :ok
      when 'Teacher'
        render json: { teachers: serialize_allocated(@teachers), total_teachers: @total_teacher_count }, status: :ok
      when 'Video'
        render json: { videos: serialize_videos(@video_lectures), videos_count: @total_video_count }, status: :ok
      when 'Ebook'
        render json: { ebooks: serialize_ebook(@total_ebooks), total_ebooks: @total_ebook_count }, status: :ok
      when 'Assignment'
        render json: { assignments: serialize_assignments(@assignments), assignments_count: @total_assignment_count }, status: :ok
      else
        render json: { student: serialize_account(@account), teachers: serialize_allocated(@teachers), total_teachers: @total_teacher_count, ebooks: serialize_ebook(@total_ebooks), total_ebooks: @total_ebook_count,assignments_count: @total_assignment_count, videos_count: @total_video_count, subjects: @subjects_array }, status: :ok
      end
    end

    def render_response_for_teacher(type)
      case type
      when 'Teacher'
        render json: { teacher: serialize_account(@teacher) }, status: :ok
      when 'Allocation'
        render json: { allocations: serialize_allocation(@subjects_data) }, status: :ok
      when 'Ebook'
        render json: { ebooks: serialize_ebooks(@total_ebook), total_ebooks: @ebooks_count }, status: :ok
      else
        render json: { teacher: serialize_account(@teacher), teacher_allocations: serialize_allocation(@subjects_data), ebooks: serialize_ebooks(@total_ebook), total_ebooks: @ebooks_count, subjects: @subjects }, status: :ok
      end
    end

    def current_user
      @account = find_account(@token&.id)
    end

    def school_admin?
      current_user.role.name == "School Admin"
    end

    def render_invalid_user_response
      render json: { message: "Invalid User Type!" }, status: :unprocessable_entity
    end

    def fetch_classes
      BxBlockCategories::SchoolClass.where(school_id: @school.id).map { |c| { id: c.id, class_number: c.class_number } }
    end

    def fetch_class_divisions
      BxBlockCategories::ClassDivision.where(school_id: @school.id).map { |c| { id: c.id, division_name: c.division_name } }
    end

    def fetch_accounts(role_name, search_name, class_id, class_division_id)
      accounts = BxBlockRolesPermissions::Role.find_by(name: role_name).accounts.where(school_id: @school.id)
      accounts = accounts.where(school_class_id: class_id) if class_id.present?
      accounts = accounts.where(school_class_id: class_id, class_division_id: class_division_id) if class_division_id.present?
      accounts = accounts.where("LOWER(first_name) LIKE ? OR LOWER(student_unique_id) LIKE ? OR LOWER(teacher_unique_id) LIKE ?", "%#{search_name}%", "%#{search_name}%", "%#{search_name}%") if search_name.present?
      accounts.page(params[:page]).per(params[:per_page])
    end

    def find_account(account_id)
      AccountBlock::Account.find_by(id: account_id)
    rescue ActiveRecord::RecordNotFound
      nil
    end

    def find_teachers(division_id, subject_name)
      teachers = BxBlockCatalogue::SubjectManagement.where(class_division_id: division_id)
      if subject_name.present?
        subject = BxBlockCatalogue::Subject.find_by(subject_name: subject_name) 
        subject_id = subject&.id
        teachers = BxBlockCatalogue::SubjectManagement.where(subject_id: subject_id, class_division_id: division_id)
      end
      teachers.page(params[:page]).per(params[:per_page])
    end

    def all_subjects
      BxBlockCatalogue::Subject.all.map { |c| { id: c.id, subject_name: c.subject_name } }
    end

    def search_ebook(search_name, class_id, subject)
      ebooks = BxBlockBulkUploading::Ebook.all
      ebooks = ebooks.where(school_class_id: class_id) if class_id.present?
      ebooks = ebooks.where(subject: subject) if subject.present?
      ebooks = ebooks.where("LOWER(title) LIKE ? OR LOWER(publisher) LIKE ?", "%#{search_name}%", "%#{search_name}%") if search_name.present?
      ebooks.page(params[:page]).per(params[:per_page])
    end

    def get_videos(class_division_id, subject_name)
      video_lectures = BxBlockCatalogue::VideosLecture.where(class_division_id: class_division_id) if class_division_id.present?
      if subject_name.present?
        subject = BxBlockCatalogue::Subject.find_by(subject_name: subject_name)
        video_lectures = video_lectures.where(subject_id: subject&.id)
      end
      video_lectures.page(params[:page]).per(params[:per_page])
    end

    def get_assignments(class_division_id, subject_name)
      assignments = BxBlockCatalogue::Assignment.where(class_division_id: class_division_id) if class_division_id.present?
      if subject_name.present?
        subject = BxBlockCatalogue::Subject.find_by(subject_name: subject_name)
        assignments = assignments.where(subject_id: subject&.id)
      end
      assignments.page(params[:page]).per(params[:per_page])
    end

    def serialize_accounts(accounts)
      AccountSerializer.new(accounts, serialization_options).serializable_hash
    end

    def serialize_account(account)
      AccountSerializer.new(account, serialization_options).serializable_hash
    end

    def serialize_allocation(subjects_data)
      TeacherAllocationSerializer.new(subjects_data, serialization_options).serializable_hash
    end

    def serialize_allocated(teachers)
      TeacherAllocatedSerializer.new(teachers, serialization_options).serializable_hash
    end

    def serialize_ebooks(ebooks)
      BxBlockElasticsearch::EbookSerializer.new(ebooks, serialization_options).serializable_hash
    end

    def serialize_ebook(ebooks)
      EbookSerializer.new(ebooks, serialization_options).serializable_hash
    end

    def serialize_videos(videos)
      VideoSerializer.new(videos, serialization_options).serializable_hash
    end

    def serialize_assignments(assignments)
      AssignmentSerializer.new(assignments, serialization_options).serializable_hash
    end

    def serialization_options
      { params: { host: request.protocol + request.host_with_port } }
    end
  end
end
