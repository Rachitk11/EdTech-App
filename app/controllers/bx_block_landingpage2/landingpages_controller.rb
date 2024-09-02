module BxBlockLandingpage2
	class LandingpagesController < ApplicationController
		before_action :validate_json_web_token, only: [:index, :student_find, :show_bundle, :show_ebooks, :show_one_book_details, :ebook_assign, :student_assigned_ebook_index, :student_assigned_assignment_index, :student_assigned_video_index, :list_subject, :class_listing, :division_listing]
		before_action :authenticate_user_type, only: [:show_bundle, :show_ebooks]

    def index
      teacher_account = AccountBlock::Account.find_by(id: @token.id)
      subject_managements = BxBlockCatalogue::SubjectManagement.where(account_id: teacher_account.id)
      students = []
      role = BxBlockRolesPermissions::Role.find_by(name: 'Student')

      subject_managements.each do |subject_management|
        class_division = subject_management.class_division
        school = class_division.school_class.school

        if class_division
          student_accounts = class_division.accounts.where(role_id: role.id)
    
          if params[:search_term].present?
            search_term = params[:search_term].downcase
            student_accounts = student_accounts
              .where("lower(student_unique_id) LIKE ? OR lower(first_name) LIKE ?", "%#{search_term}%", "%#{search_term}%")
          end

          if params[:class_number].present?
            school_class = school.school_classes&.find_by(class_number: params[:class_number])
            student_accounts = student_accounts&.where(school_class_id: school_class&.id)
          end

          if params[:class_division].present? && school_class.present?
            class_division = school_class.class_divisions&.find_by(division_name: params[:class_division])
            student_accounts = student_accounts&.where(class_division_id: class_division&.id) 
          end

          students += student_accounts.to_a if student_accounts.present?
        end
      end
    
      if students.present?
        paginated_students = Kaminari.paginate_array(students.uniq).page(params[:page]).per(params[:per_page])
        count = students.count
        landingpage_serializer = BxBlockLandingpage2::LandingpageSerializer.new(paginated_students, serialization_options)
        render json: landingpage_serializer.serializable_hash.merge(meta: { count: count })
      else
        render json: { error: 'No students found' }, status: :not_found
      end
    end

		def student_find
      @student = AccountBlock::Account.find_by(id: params[:id])

      if @student.present?
        render json: BxBlockLandingpage2::LandingpageSerializer.new(@student, serialization_options)
      else
        render json: { error: 'No student found with the given ID and class division' }, status: :unprocessable_entity
      end
		end		

    def student_assigned_assignment_index
      student = AccountBlock::Account.find(params[:id])
      classdivision = student.class_division
      subject_managements = classdivision.subject_managements
      ids = subject_managements.pluck(:id)
      subject_filter = params[:subject]

      if subject_filter.present?
        subject_id = BxBlockCatalogue::Subject.find_by(subject_name: subject_filter)&.id
        ids = subject_managements.where(subject_id: subject_id).pluck(:id) if subject_id
      end

      assignments = BxBlockCatalogue::Assignment.where(subject_management_id: ids)
      paginated_assignments = assignments.page(params[:page]).per(params[:per_page])

      assignments_data = paginated_assignments.map do |assignment|
        {
          assignment_title: assignment.title,
          subject_name: assignment.subject_management.subject.subject_name,
          # date_assigned: assignment.created_at
          date_assigned: assignment.created_at.strftime("%-d %b %Y")
        }
      end
      render json: { assignments: assignments_data, count: assignments.uniq.count }, status: :ok
    end

    def student_assigned_video_index
      student = AccountBlock::Account.find(params[:id])
      classdivision = student.class_division
      subject_managements = classdivision.subject_managements
      ids = subject_managements.pluck(:id)
      subject_filter = params[:subject]

      if subject_filter.present?
        subject_id = BxBlockCatalogue::Subject.find_by(subject_name: subject_filter)&.id
        ids &= subject_managements.where(subject_id: subject_id).pluck(:id) if subject_id
      end

      videos_lectures = BxBlockCatalogue::VideosLecture.where(subject_management_id: ids)
      paginated_videos = videos_lectures.page(params[:page]).per(params[:per_page])

      videos_data = paginated_videos.map do |video|
        {
          video_title: video.title,
          subject_name: video.subject_management.subject.subject_name,
          date_assigned: video.created_at
        }
      end
    
      render json: { videos_data: videos_data, count: videos_lectures.count }, status: :ok
    end
				
		def show_bundle
			@collections = BxBlockBulkUploading::BundleManagement.all

			if @collections.present?
        render json: BxBlockBulkUploading::BundleManagementSerializer.new(@collections,serialization_options).serializable_hash, status: :ok
			else
        render json: { error: 'Empty' }, status: :unprocessable_entity
			end
	  end

		def show_ebooks
			@collections = BxBlockBulkUploading::Ebook.all

			if params[:subject].present?
				@collections = @collections.where(subject: params[:subject])
			end

			if params[:search_term].present?
        search_term = params[:search_term].downcase
        @collections = @collections.select { |ebook| ebook.title.downcase.include?(search_term) || ebook.author.downcase.include?(search_term) }
			end

			if @collections.any?
				render json: BxBlockBulkUploading::EbookSerializer.new(@collections, serialization_options).serializable_hash, status: :ok
			else
        render json: { error: 'No matching books found.' }, status: :not_found
			end
		end

		def show_one_book_details
			@ebook = BxBlockBulkUploading::Ebook.find(params[:id])

			if @ebook.present?
				render json: BxBlockBulkUploading::EbookSerializer.new(@ebook, serialization_options).serializable_hash, status: :ok
			end
	  end

    def student_assigned_ebook_index
      student = AccountBlock::Account.find_by(id: params[:id])
      student_ebooks = BxBlockBulkUploading::EbookAllotment.where(student_id: params[:id])

      if params[:subject].present?
        student_ebooks = student_ebooks.joins(:ebook).where(bx_block_bulk_uploading_ebooks: { subject: params[:subject] })
      end

      stud_ebooks = student_ebooks.uniq.map(&:ebook)
      stud_ebooks.uniq!(&:id)
      paginated_ebook = Kaminari.paginate_array(stud_ebooks).page(params[:page]).per(params[:per_page])

      alloted_ebooks_details = paginated_ebook.map do |ebook|
        {
          title: ebook.title,
          subject: ebook.subject,
          allotted_date: ebook.ebook_allotments.find_by(student_id: student.id)&.alloted_date
        }
      end

      total_count = stud_ebooks.count
      render json: { ebooks: alloted_ebooks_details, total_assigned_ebook: total_count }, status: :ok
    end

    def list_subject
      subjects =  BxBlockCatalogue::Subject.all

      if subjects.present?
        subjects_data = subjects.map { |subject| { id: subject.id, name: subject.subject_name } }
        render json: { subjects: subjects_data }, status: :ok
      else
        render json: { error: 'Subject Not found.' }, status: :not_found
      end
    end

    def class_listing
      account = AccountBlock::Account.find_by(id: @token.id)
      school = account.school
      school_classes = school.school_classes.select(:id, :class_number)
      if school_classes.present?
        render json: { school_classes: school_classes }, status: :ok
      else
        render json: { error: 'Class Not found.' }, status: :not_found
      end
    end

    def division_listing
      account = AccountBlock::Account.find_by(id: @token.id)
      school = account.school
      classes = school.school_classes.includes(:class_divisions)
      all_divisions = []
      classes.each do |classroom|
        all_divisions.concat(classroom.class_divisions.select(:id, :division_name))
      end
        unique_divisions = all_divisions.uniq(&:division_name)
        render json: { divisions: unique_divisions }, status: :ok
    end
  

		private

		def serialization_options
			{ params: { host: request.protocol + request.host_with_port } }
		end

		def authenticate_user_type
			acc = AccountBlock::Account.find_by(id: @token.id)
			name = acc&.role&.name
			allowed_user_types = ['Student', 'Teacher', 'School Admin']

			unless allowed_user_types.include?(name)
				head :unauthorized
				return
			end
		end
	end
end
