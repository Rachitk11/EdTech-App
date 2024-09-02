module BxBlockCatalogue
  class StudyMaterialsController < ApplicationController
    before_action :current_user, only: :update_video_status

    def video_and_assignment_for_student
      if current_user.role.name == "Student"
        class_division_id = current_user.class_division&.id
        video_lectures = BxBlockCatalogue::VideosLecture.where(class_division_id: class_division_id)
        assignments = BxBlockCatalogue::Assignment.where(class_division_id: class_division_id)
        subjects = BxBlockCatalogue::Subject.all.map { |subject| { subject_name: subject.subject_name } } 
        type = params[:type]
        filter_subject = params[:subject_name]
        search_text = params[:video_search]

        if type == 'video'
          video_lectures = apply_video_filters(video_lectures, filter_subject, search_text)
          video_lectures = video_lectures.page(params[:page]).per(params[:per_page]) 
          render json: {
            video_lectures: BxBlockCatalogue::VideoSerializer.new(video_lectures).serializable_hash,
            video_count: video_lectures.count
            }, status: :ok
        elsif type == 'assignment'
          assignments = apply_assignment_filters(assignments, filter_subject)
          assignments = assignments.page(params[:page]).per(params[:per_page])
          render json: {
            assignments: BxBlockCatalogue::AssignmentSerializer.new(assignments).serializable_hash, assignment_count: assignments.count
          }, status: :ok
        else
          render json: {
            video_lectures: BxBlockCatalogue::VideoSerializer.new(video_lectures.page(params[:page]).per(params[:per_page])).serializable_hash,
            assignments: BxBlockCatalogue::AssignmentSerializer.new(assignments.page(params[:page]).per(params[:per_page])).serializable_hash,
            subjects: subjects, video_count: video_lectures.count, assignment_count: assignments.count
          }, status: :ok
        end
      else
        render json: { message: "You are not authorized "}, status: 422
      end
    end

    def video_and_assignment(user_scope, type)
      school = current_user.school
      video_lectures = BxBlockCatalogue::VideosLecture.where(user_scope)
      assignments = BxBlockCatalogue::Assignment.where(user_scope)
      school_class = BxBlockCategories::SchoolClass.where(school_id: school.id).pluck(:class_number).uniq.sort
      class_division = BxBlockCategories::ClassDivision.where(school_id: school.id).pluck(:division_name).uniq.sort
      ebooks = BxBlockBulkUploading::EbookAllotment.where(user_scope)
      search_class = params[:school_class]
      search_division = params[:division]

      @school_class = BxBlockCategories::SchoolClass.find_by(class_number: search_class)
      @division = BxBlockCategories::ClassDivision.find_by(division_name: search_division, school_class_id: @school_class&.id)
      case type
      when 'video'
        if search_class&.present? && search_division&.present?
          video_lectures = video_lectures.where(school_class_id: @school_class&.id, class_division_id: @division&.id)
        elsif search_class&.present?
          video_lectures = video_lectures.where(school_class_id: @school_class&.id)
        end
        { video_lectures: BxBlockCatalogue::VideoSerializer.new(video_lectures.page(params[:page]).per(params[:per_page])).serializable_hash, 
          video_count: video_lectures.count, school_class: school_class, class_division: class_division
         }
      when 'assignment'
        if search_class&.present? && search_division&.present?
          assignments = assignments.where(school_class_id: @school_class&.id, class_division_id: @division&.id)
        elsif search_class&.present?
          assignments = assignments.where(school_class_id: @school_class&.id)
        end
        { assignments: BxBlockCatalogue::AssignmentSerializer.new(assignments.page(params[:page]).per(params[:per_page])).serializable_hash ,
          assignment_count: assignments.count , school_class: school_class, class_division: class_division
        }
      when 'ebook'
        if search_class&.present? && search_division&.present?
          ebooks = ebooks.where(school_class_id: @school_class&.id, class_division_id: @division&.id)
        elsif search_class&.present?
          ebooks = ebooks.where(school_class_id: @school_class&.id)
        end
        { ebook: BxBlockCatalogue::EbookAssignedSerializer.new(ebooks.page(params[:page]).per(params[:per_page])).serializable_hash,
          ebook_count: ebooks.count , school_class: school_class, class_division: class_division
         }
      else
        {
          video_lectures: BxBlockCatalogue::VideoSerializer.new(video_lectures.page(params[:page]).per(params[:per_page])).serializable_hash,
          assignments: BxBlockCatalogue::AssignmentSerializer.new(assignments.page(params[:page]).per(params[:per_page])).serializable_hash,
          ebooks:  BxBlockCatalogue::EbookAssignedSerializer.new(ebooks.page(params[:page]).per(params[:per_page])).serializable_hash,
          ebook_count: ebooks.count,
          video_count: video_lectures.count,
          assignment_count: assignments.count , school_class: school_class, class_division: class_division
        }
      end

    end

    def video_and_assignment_for_teacher
      if current_user.role.name == "Teacher"
        user_scope = { account_id: current_user.id }
        type = params[:type]
        data = video_and_assignment(user_scope, type)
        render json: data, status: :ok
      else
        render json: { message: "You are not authorized"}, status: 422
      end
    end

    def video_and_assignment_for_school_admin
      if current_user.role.name == "School Admin"
        user_scope = { school_id: current_user.school_id }
        type = params[:type]
        data = video_and_assignment(user_scope, type)
        render json: data, status: :ok
      else
        render json: { message: "You are not authorized"}, status: 422
      end
    end

    def student_details(resource_type)
      resource = nil
      case resource_type
      when 'video'
        resource = BxBlockCatalogue::VideosLecture.find_by(id: params[:video_id])
      when 'assignment'
        resource = BxBlockCatalogue::Assignment.find_by(id: params[:assignment_id])
      when 'ebook'
        ebook_allotment = BxBlockBulkUploading::EbookAllotment.find_by(id: params[:assign_ebook_id])
        resource = BxBlockBulkUploading::Ebook.find_by(id: ebook_allotment.ebook_id)
      else
        render json: { message: "Invalid type" }, status: 422
      end
      if resource_type == 'ebook'
        students = AccountBlock::Account.where(role_id: BxBlockRolesPermissions::Role.where(name: "Student"))
                                      .where(class_division_id: ebook_allotment&.class_division_id, school_class_id: ebook_allotment&.school_class_id, school_id: ebook_allotment&.school_id)
        render json: {
          ebook: BxBlockBulkUploading::EbookSerializer.new(resource).serializable_hash,
          students: BxBlockCatalogue::StudentSerializer.new(students.page(params[:page]).per(params[:per_page]), serialization_options).serializable_hash,
          students_count: students.count
        }, status: :ok  
      else                            
        students = AccountBlock::Account.where(role_id: BxBlockRolesPermissions::Role.where(name: "Student"))
                                        .where(class_division_id: resource&.class_division_id, school_class_id: resource&.school_class_id, school_id: resource&.school_id)

        render json: {
          "#{resource_type}": "BxBlockCatalogue::#{resource_type.capitalize}Serializer".constantize.new(resource).serializable_hash,
          students: BxBlockCatalogue::StudentSerializer.new(students.page(params[:page]).per(params[:per_page]), serialization_options).serializable_hash,
          students_count: students.count
        }, status: :ok
      end

    end

    def student_details_video
      student_details('video')
    end

    def student_details_assignment
      student_details('assignment')
    end

    def student_details_ebook
      student_details('ebook')
    end

    def update_video_status
      video = BxBlockCatalogue::VideosLecture.find_by(id: params[:data][:video_id])
      if video.present?
        @account.student_videos.create(videos_lecture_id: video.id, status: true)
        render json: {data: {message: 'Video lecture is completed'} }, status: :ok
      else
        render json: {data: {error: 'Video not found'} }, status: :not_found
      end
    end

    private
    
    def apply_video_filters(video_lectures, filter_subject, search_text)
      if filter_subject.present?
        subject = BxBlockCatalogue::Subject.find_by(subject_name: filter_subject)
        video_lectures = video_lectures.where(subject_id: subject&.id)
      end

      video_lectures = video_lectures.where('title LIKE ?', "%#{search_text}%") if search_text.present?

      video_lectures
    end

    def apply_assignment_filters(assignments, filter_subject)
      if filter_subject.present?
        subject = BxBlockCatalogue::Subject.find_by(subject_name: filter_subject)
        assignments = assignments.where(subject_id: subject&.id)
      end

      assignments
    end

    def serialization_options
      { params: { video_lecture_id: params[:video_id], assignment_id: params[:assignment_id], ebook_id: params[:assign_ebook_id] } }
    end

    def current_user
      @account = AccountBlock::Account.find_by(id: @token.id)
    end
  end
end
