require 'rails_helper'

RSpec.describe BxBlockLandingpage2::SchoolAdminLandingpagesController, type: :controller do
  before(:each) do
    @student_role = FactoryBot.create(:role, name: "Student")
    @teacher_role = FactoryBot.create(:role, name: "Teacher")
    @school_admin_role = FactoryBot.create(:role, name: "School Admin")
    # @student_account = FactoryBot.create(:account, role_id: @student_role.id , student_unique_id: "STU59635", first_name: 'XYZ')
    @teacher_account = FactoryBot.create(:account, role_id: @teacher_role.id, teacher_unique_id: "TECH22055")
    @school = FactoryBot.create(:school, name: "DDPSIC", phone_number: "2262256995")
    @school_admin_account = FactoryBot.create(:account, role_id: @school_admin_role.id, school_id: @school.id )
    @school_admin_token = BuilderJsonWebToken.encode(@school_admin_account.id)
    @ebooks = BxBlockBulkUploading::Ebook.all
    @videos = BxBlockCatalogue::VideosLecture.all
    @assignments = BxBlockCatalogue::Assignment.all
    @subjects = BxBlockCatalogue::Subject.all
    @class_division = FactoryBot.create(:class_division, school_class_id: nil, account_id: @teacher_account.id, division_name: "A")
    @school_class = FactoryBot.create(:school_class, school_id: @school.id, class_divisions: [@class_division], class_number: 1)
    @subject = BxBlockCatalogue::Subject.find_or_create_by(subject_name: 'maths')
    @student_account = FactoryBot.create(:account, role_id: @student_role.id , student_unique_id: "ST9635", class_division_id: @class_division.id, school_class_id: @school_class.id, school_id: @school.id)
    @subject_management = BxBlockCatalogue::SubjectManagement.find_or_create_by(subject_id: @subject.id, account_id: @teacher_account.id)
    subject_management = BxBlockCatalogue::SubjectManagement.find_by(id: @subject_management.id)
    @video = BxBlockCatalogue::VideosLecture.find_or_create_by(title: "video", description: "this is video", subject_id:  @subject.id, subject_management: subject_management, account_id: @teacher_account.id, class_division_id: @class_division.id, school_class_id: @school_class.id, video: "https://www.youtube.com/watch?v=t4R60Tc5nho", school_id: @school.id)

    pdf_file = Tempfile.new(['example', '.pdf'])
    pdf_file.write('PDF content goes here') 
    pdf_file.rewind

    pdf_blob = ActiveStorage::Blob.create_and_upload!(
      io: pdf_file,
      filename: 'example.pdf',
      content_type: 'application/pdf'
    )
    @assignment = BxBlockCatalogue::Assignment.new(title: "video", description: "this is PDF", subject_id:  @subject.id, subject_management: subject_management, account_id: @teacher_account.id, class_division_id: @class_division.id, school_class_id: @school_class.id, school_id: @school.id)

    @assignment.assignment.attach(pdf_blob)
    @assignment.save
    @ebook = FactoryBot.create(:ebook)
    # @ebook_allotment = BxBlockBulkUploading::EbookAllotment.create(account_id: @teacher_account.id, student_id: @student_account.id, ebook_id: @ebook.id, alloted_date: Date.today, school_class_id: @school_class.id, class_division_id: @class_division.id, school_id: @school.id)
    
    @student_token = BuilderJsonWebToken.encode(@student_account.id)

  end

  describe 'GET #get_users' do
    it 'returns a successful response' do
      params = { token: @school_admin_token, database_type: "", search_name: 'XYZ', class_number: '', class_division_name: ''}
      get :get_users, params: params
      expect(response).to have_http_status(:ok)
    end

    it 'returns a successful response when database type is Teacher' do
      params = { token: @school_admin_token, database_type: 'Teacher', search_name: '', class_number: '', class_division_name: ''}
      get :get_users, params: params
      expect(response).to have_http_status(:ok)
    end
    it 'returns a successful response when database type is Student' do
      params = { token: @school_admin_token, database_type: 'Student', search_name: '', class_number: '', class_division_name: '' }
      get :get_users, params: params
      expect(response).to have_http_status(:ok)
    end
    it 'returns a successful response when database type is Publisher' do
      params = { token: @school_admin_token, database_type: 'Publisher', search_name: '', class_number: '', class_division_name: ''}
      get :get_users, params: params
      expect(response).to have_http_status(:ok)
    end
    it 'returns unprocessable_entity with error message' do
      params = { token: @student_token, search_name: '', class_number: '', class_division_name: ''}
      get :get_users, params: params
      expect(response).to have_http_status(:unprocessable_entity)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['message']).to eq('Invalid User!')
    end
    it 'returns a not found message!' do
        @teacher_account.delete
        @student_account.delete
        @school_admin_account.delete
        params = { token: @school_admin_token, id: 'invalid'}
        get :get_users, params: params

        expect(response).to have_http_status(:unprocessable_entity)
      end
  end

  describe 'GET #show_teacher_detail' do

    context 'when user is present' do

      it 'returns a successful response when type is teacher' do
        params = { token: @school_admin_token, id: @teacher_account.id, type: "Teacher", search_name: ""}
        get :show_teacher_detail, params: params
        expect(response).to have_http_status(:ok)
      end

      it 'returns a successful response when type is allocation' do
        params = { token: @school_admin_token, id: @teacher_account.id, type: "Allocation", search_name: ""}
        get :show_teacher_detail, params: params
        expect(response).to have_http_status(:ok)
      end

      it 'returns a successful response when type is ebook' do
        params = { token: @school_admin_token, id: @teacher_account.id, type: "Ebook", search_name: ""}
        get :show_teacher_detail, params: params
        expect(response).to have_http_status(:ok)
      end

      it 'returns a successful response when type is null' do
        params = { token: @school_admin_token, id: @teacher_account.id, type: "", search_name: ""}
        get :show_teacher_detail, params: params
        expect(response).to have_http_status(:ok)
      end

      it 'returns a not found message!' do
        @teacher_account.delete
        @student_account.delete
        @school_admin_account.delete
        params = { token: @school_admin_token, id: 'invalid', search_name: ""}
        get :show_teacher_detail, params: params

        expect(response).to have_http_status(:internal_server_error)
      end
      it 'returns unprocessable_entity with error message!' do
        params = { token: @student_token, search_name: ""}
        get :show_teacher_detail, params: params
        expect(response).to have_http_status(:unprocessable_entity)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to eq('Invalid User Type!')
      end
    end
  end

  describe 'GET #show_student_detail' do

    context 'when user is present' do

      it 'returns a successful response when content_type is teacher' do
        params = { token: @school_admin_token, id: @student_account.id, content_type: "Teacher", page: 1, per_page: 2, filter_subject: 'Physics'}
        get :show_student_detail, params: params
        expect(response).to have_http_status(:ok)
      end

      it 'returns a successful response when content_type is student' do
        params = { token: @school_admin_token, id: @student_account.id, content_type: "Student", page: 1, per_page: 2, filter_subject: ''}
        get :show_student_detail, params: params
        expect(response).to have_http_status(:ok)
      end

      it 'returns a successful response when content_type is Video' do
        params = { token: @school_admin_token, id: @student_account.id, content_type: "Video", page: 1, per_page: 2, filter_subject: ''}
        get :show_student_detail, params: params
        expect(response).to have_http_status(:ok)
      end

      it 'returns a successful response when content_type is Assignment' do
        params = { token: @school_admin_token, id: @student_account.id, content_type: "Assignment", page: 1, per_page: 2, filter_subject: ''}
        get :show_student_detail, params: params
        expect(response).to have_http_status(:ok)
      end

      it 'returns a successful response when content_type is ebook' do
        params = { token: @school_admin_token, id: @student_account.id, content_type: "Ebook", page: 1, per_page: 2, filter_subject: ''}
        get :show_student_detail, params: params
        expect(response).to have_http_status(:ok)
      end

      it 'returns a successful response when content_type is null' do
        params = { token: @school_admin_token, id: @student_account.id, content_type: "", page: 1, per_page: 2, filter_subject: 'Physics'}
        get :show_student_detail, params: params
        expect(response).to have_http_status(:ok)
      end

      it 'returns a not found message when user id is invalid' do
        params = { token: @school_admin_token, id: 'invalid', content_type: "Student", page: 1, per_page: 2, filter_subject: 'Physics'}
        get :show_student_detail, params: params
        expect(response).to have_http_status(:not_found)
      end
      it 'returns unprocessable_entity with error message!' do
        params = { token: @student_token}
        get :show_student_detail, params: params
        expect(response).to have_http_status(:unprocessable_entity)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to eq('Invalid User Type!')
      end
    end
  end
end
