module BxBlockElasticsearch
  class SearchController < ApplicationController
    before_action :validate_json_web_token, :current_user
    respond_to? :html, :json

    def search_content
      @term = params[:term]

      if @term.blank?
        render json: { error: "No search term provided" }, status: :bad_request
        return
      end

      if current_user.present?
        @school = current_user.school
        @class_division_id = current_user.class_division&.id

        case current_user.role.name
        when 'School Admin', 'Teacher'
          search_for_teacher_or_admin
        when 'Student'
          search_for_student
        else
          render json: { message: 'Invalid User Type!' }, status: :unprocessable_entity
        end
      else
        render json: { message: 'User Not Found!' }, status: :not_found
      end
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def search_for_teacher_or_admin
      @ebooks = search_ebooks.result
      @accounts = search_accounts.result
      @assignments = search_assignments_for_school_and_teacher.result

      render_search_results
    end

    def search_for_student
      @ebooks = search_ebooks.result
      @accounts = search_accounts.result
      @assignments = search_assignments_for_students.result

      render_search_results
    end

    def render_search_results
      if @ebooks.present? && @accounts.present? && @assignments.present?
        render json: { ebooks: serialize_ebooks(@ebooks), accounts: serialize_accounts(@accounts), assignments: serialize_assignments(@assignments) }, status: :ok
      elsif @ebooks.present? && @accounts.present?
        render json: { ebooks: serialize_ebooks(@ebooks), accounts: serialize_accounts(@accounts) }, status: :ok
      elsif @ebooks.present? && @assignments.present?
        render json: { ebooks: serialize_ebooks(@ebooks), assignments: serialize_assignments(@assignments) }, status: :ok
      elsif @accounts.present? && @assignments.present?
        render json: { accounts: serialize_accounts(@accounts), assignments: serialize_assignments(@assignments) }, status: :ok
      elsif @ebooks.present?
        render json: { ebooks: serialize_ebooks(@ebooks) }, status: :ok
      elsif @accounts.present?
        render json: { accounts: serialize_accounts(@accounts) }, status: :ok
      elsif @assignments.present?
        render json: { assignments: serialize_assignments(@assignments) }, status: :ok
      else
        render json: { message: "No results found for '#{@term}'. Please try a different search term." }, status: :not_found
      end
    end

    def current_user
      @account = find_account(@token&.id)
    end

    def find_account(account_id)
      AccountBlock::Account.find_by(id: account_id)
    rescue ActiveRecord::RecordNotFound
      nil
    end

    def search_accounts
      accounts = AccountBlock::Account.all.where(school_id: @school.id)
      accounts.ransack(first_name_or_last_name_cont: @term)
    end

    def search_assignments_for_students
      assignments = BxBlockCatalogue::Assignment.where(class_division_id: @class_division_id)
      assignments.ransack(title_cont: @term)
    end

    def search_assignments_for_school_and_teacher
      assignments = BxBlockCatalogue::Assignment.where(school_id: @school.id)
      assignments.ransack(title_cont: @term)
    end

    def search_ebooks
      BxBlockBulkUploading::Ebook.ransack(title_or_publisher_cont: @term)
    end

    def serialize_accounts(accounts)
      AccountSerializer.new(accounts).serializable_hash
    end

    def serialize_ebooks(ebooks)
      EbookSerializer.new(ebooks, serialization_options).serializable_hash
    end

    def serialize_assignments(assignments)
      AssignmentSerializer.new(assignments).serializable_hash
    end


    def serialization_options
      { params: { host: request.protocol + request.host_with_port } }
    end
  end
end
