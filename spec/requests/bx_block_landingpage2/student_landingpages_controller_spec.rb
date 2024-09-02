require 'rails_helper'

RSpec.describe BxBlockLandingpage2::StudentLandingpagesController, type: :controller do
  before(:each) do
    @teacher_role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Teacher')
    @school = FactoryBot.create(:school, name: 'BGPS', phone_number: 7890654321)
    @teacher = FactoryBot.create(:account, role_id: @teacher_role.id, school_id: @school.id)
    @class_division = FactoryBot.create(:class_division, school_class_id: nil, account_id: @teacher.id)
    @school_class = FactoryBot.create(:school_class, school_id: @school.id, class_divisions: [@class_division])
    @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
    @student_account = FactoryBot.create(:account, role_id: @role.id, class_division_id: @class_division.id, activated: true)
    @token = BuilderJsonWebToken.encode(@student_account.id)
    @ebook1 = FactoryBot.create(:ebook, title: 'Math Book', subject: 'Math', author: 'John Doe', school_class_id: @school_class.id)
    @subject = BxBlockCatalogue::Subject.create(subject_name: "abc", class_division_id: @class_division.id )
    @subject_management = BxBlockCatalogue::SubjectManagement.create(class_division_id:  @class_division.id, account_id: @teacher.id, subject_id:@subject.id )

    pdf_file = Tempfile.new(['example', '.pdf'])
	  pdf_file.write('PDF content goes here') 
	  pdf_file.rewind
	  pdf_blob = ActiveStorage::Blob.create_and_upload!(
	    io: pdf_file,
	    filename: 'example.pdf',
	    content_type: 'application/pdf'
	  )
		@assignment = BxBlockCatalogue::Assignment.new(title: "video", description: "this is PDF", subject_id:  @subject.id, subject_management: @subject_management, account_id: @teacher.id, class_division_id: @class_division.id, school_class_id: @school_class.id)

		@assignment.assignment.attach(pdf_blob)
		@assignment.save
  
  end

  describe 'GET #ebook_show_all' do
    context 'when valid parameters are provided' do
      it 'returns a list of ebooks' do
        ebook3 = FactoryBot.create(:ebook)
        ebook4 = FactoryBot.create(:ebook)
        ebook5 = FactoryBot.create(:ebook)
    
        BxBlockBulkUploading::RemoveBook.create(account_id: @student_account.id, ebook_id: ebook3.id)

        get :ebook_show_all, params: { token: @token, subject: 'Java', search_term: ebook3.title }

        expect(response).to have_http_status(:not_found)
      end
    end

    it 'returns a list of according search ebooks' do
      class_id = @student_account.class_division.school_class.class_number
      books = create_list(:ebook, 5, school_class_id: class_id)

      get :ebook_show_all, params: { token: @token }

      expect(response).to have_http_status(:ok)
    end

    it 'No matching books found' do
      ebook3 = FactoryBot.create(:ebook)
     
      BxBlockBulkUploading::RemoveBook.create(account_id: @student_account.id, ebook_id: ebook3.id)

      get :ebook_show_all, params: { token: @token, subject: 'Java' }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #hide_ebook' do
    context 'when valid parameters and PIN are provided' do
      it 'hides the ebook successfully' do
        ebook = FactoryBot.create(:ebook)
        @student_account.update(pin: '1234', activated: true)
       
        post :hide_ebook, params: { token: @token, ebook_id: ebook.id, pin: '1234' }

        expect(response).to have_http_status(:ok)
      end

      context 'when valid parameters and PIN are provided' do
        it 'hides the ebook successfully' do
          ebook = FactoryBot.create(:ebook)

          @student_account.update(pin: '1234', activated: true)
          post :hide_ebook, params: { token: @token, ebook_id: ebook.id, pin: '12345' }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'GET #assigned_assignment_index' do
    it 'returns a list of assignments for the given student' do
      @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
      student = FactoryBot.create(:account, role_id: @role.id, class_division_id: @class_division.id, activated: true)

      get :assigned_assignment_index, params: { id: student.id, token: @token }

      expect(response).to have_http_status(:ok)
    end

    it 'returns a list of assignments for the given student with subject filter' do
      @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
      student = FactoryBot.create(:account, role_id: @role.id, class_division_id: @class_division.id, activated: true)

      get :assigned_assignment_index, params: { id: student.id, token: @token, subject: @subject.subject_name }

      expect(response).to have_http_status(:ok)
    end

    it 'returns an empty list with assignment title filter' do
      @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
      student = FactoryBot.create(:account, role_id: @role.id, class_division_id: @class_division.id, activated: true)

      get :assigned_assignment_index, params: { id: student.id, token: @token, assignment_title: 'Sample Assignment' }

      expect(response).to have_http_status(404)
    end

    it "returns an error when subject is not found" do
      @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
      student = FactoryBot.create(:account, role_id: @role.id, class_division_id: @class_division.id, activated: true)

      get :assigned_assignment_index, params: { id: student.id, token: @token, subject: "Nonexistent Subject" }

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)['error']).to eq('no assignment found.')
    end


    it 'returns an not found' do
      @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
      student = FactoryBot.create(:account, role_id: @role.id, class_division_id: @class_division.id, activated: true)
     
      get :assigned_assignment_index, params: { id: student.id, token: @token, assignment_title: 'invalid' }

      expect(response).to have_http_status(:not_found)
    end
  end
end