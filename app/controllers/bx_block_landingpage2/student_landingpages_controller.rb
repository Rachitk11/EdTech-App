module BxBlockLandingpage2
	class StudentLandingpagesController < ApplicationController
    before_action :validate_json_web_token, only: [:assigned_assignment_index,:ebook_show_all, :hide_ebook]

    def ebook_show_all
      student = AccountBlock::Account.find_by(id: @token.id)
      class_id = student&.class_division&.school_class&.class_number
      @books = BxBlockBulkUploading::Ebook.where(school_class_id: class_id)

			if params[:subject].present?
				@books = @books.where(subject: params[:subject])
			end

			if params[:search_term].present?
        search_term = params[:search_term].downcase
        @books = @books.where("LOWER(title) LIKE ? OR LOWER(author) LIKE ?", "%#{search_term}%", "%#{search_term}%")
			end

      hidden_ebook_ids = BxBlockBulkUploading::RemoveBook.where(account_id: student.id).pluck(:ebook_id)
      @books = @books.where.not(id: hidden_ebook_ids)

      @books = @books.page(params[:page]).per(params[:per_page])
      total_count = @books.total_count
      if @books.present?
        student_landingpage_serializer = BxBlockBulkUploading::EbookSerializer.new(@books, serialization_options)
        render json:  student_landingpage_serializer.serializable_hash.merge(meta: { count: total_count }), status: :ok
      else
        render json: { error: 'No book found.' }, status: :not_found
      end
    end

    def hide_ebook
      student = AccountBlock::Account.find_by(id: @token.id)
      ebook = BxBlockBulkUploading::Ebook.find_by(id: params[:ebook_id])

      if student && ebook

        if params[:pin].present? && authenticate_pin(params[:pin])
          BxBlockBulkUploading::RemoveBook.create(account_id: student.id, ebook_id: ebook.id)
          render json: { success: 'Ebook delete successfully.' }, status: :ok
        else
          render json: { error: 'Invalid PIN. Please provide a valid PIN to delete the ebook.' }, status: :unprocessable_entity
        end

      end
    end

    def assigned_assignment_index
      student = AccountBlock::Account.find_by(id: @token.id)
      classdivision = student.class_division
      subject_managements = classdivision.subject_managements
      ids = subject_managements.pluck(:id)
      subject_filter = params[:subject]

      if subject_filter.present?
        subject_id = BxBlockCatalogue::Subject.find_by(subject_name: subject_filter)&.id
        if subject_id
          ids = subject_managements.where(subject_id: subject_id).pluck(:id)
        else
          render json: { error: 'no assignment found.' }, status: :not_found
          return
        end 
      end

      assignments = BxBlockCatalogue::Assignment.where(subject_management_id: ids)

      assignment_title_filter = params[:assignment_title]
      if assignment_title_filter.present?
        assignment_title_filter = params[:assignment_title].downcase
        assignments = assignments.where("LOWER(title) LIKE ?", "%#{assignment_title_filter}%")
      end

      paginated_assignments = assignments.page(params[:page]).per(params[:per_page])

      assignments_data = paginated_assignments.map do |assignment|
        teacher = AccountBlock::Account.find_by(id: assignment.account_id)
        {
          assignment_title: assignment.title,
          subject_name: assignment.subject_management.subject.subject_name,
          assigned_by: teacher&.first_name
        }
      end
      if assignments_data.present?
        render json: { assignments: assignments_data, count: assignments_data.count }, status: :ok
      else
        render json: { error: 'No assignment found.' }, status: :not_found
      end
    end

    private

    def authenticate_pin(pin)
      student = AccountBlock::Account.find_by(id: @token.id)
      pin == student.pin
    end

		def serialization_options
			{ params: { host: request.protocol + request.host_with_port } }
		end

  end
end
