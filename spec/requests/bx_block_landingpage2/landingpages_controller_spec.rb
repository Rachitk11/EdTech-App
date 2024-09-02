require 'rails_helper'

RSpec.describe BxBlockLandingpage2::LandingpagesController, type: :controller do
  before(:each) do
	  @teacher_role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Teacher')
	  @school = FactoryBot.create(:school, name: 'BGPS', phone_number: 7890654321)
	  @teacher = FactoryBot.create(:account, role_id: @teacher_role.id, school_id: @school.id)
	  @class_division = FactoryBot.create(:class_division, school_class_id: nil, account_id: @teacher.id)
		@school_class = FactoryBot.create(:school_class, school_id: @school.id, class_divisions: [@class_division])
    @token = BuilderJsonWebToken::JsonWebToken.encode(@teacher.id)
  end

  STD = "John"

    describe 'GET #index' do
      it 'returns a unprocessble entiy error' do
        @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
        student = FactoryBot.create(:account, first_name: STD, role_id: @role.id, class_division_id: @class_division.id, activated: true)
        subject = BxBlockCatalogue::Subject.create(subject_name: "abc", class_division_id: @class_division.id )
        subject_management = BxBlockCatalogue::SubjectManagement.create(class_division_id:  @class_division.id, 
          account_id: @teacher.id,        
          subject_id:subject.id        
        )
        get :index, params: { token: @token, search_term: student.first_name, class_number: @school_class.class_number, class_division: @class_division.division_name }
        expect(response).to have_http_status(404)
      end

      it 'returns a successful response according search' do
        @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
        student = FactoryBot.create(:account, first_name: STD, role_id: @role.id, class_division_id: @class_division.id, activated: true)
        subject = BxBlockCatalogue::Subject.create(subject_name: "abc", class_division_id: @class_division.id )
        subject_management = BxBlockCatalogue::SubjectManagement.create(class_division_id:  @class_division.id, 
          account_id: @teacher.id,        
          subject_id:subject.id        
        )
        get :index, params: { token: @token, search_term: student.first_name }
        expect(response).to have_http_status(200)
      end

      it 'returns a successful response of all student' do
        @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
        student = FactoryBot.create(:account, first_name: STD, role_id: @role.id, class_division_id: @class_division.id, activated: true)
        subject = BxBlockCatalogue::Subject.create(subject_name: "abc", class_division_id: @class_division.id )
        subject_management = BxBlockCatalogue::SubjectManagement.create(class_division_id:  @class_division.id, 
          account_id: @teacher.id,        
          subject_id:subject.id        
        )
        get :index, params: { token: @token }
        expect(response).to have_http_status(200)
      end

      it 'returns a successful response according class division filter' do
        @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
        student = FactoryBot.create(:account, first_name: STD, role_id: @role.id, class_division_id: @class_division.id, activated: true)
        subject = BxBlockCatalogue::Subject.create(subject_name: "abc", class_division_id: @class_division.id )
        subject_management = BxBlockCatalogue::SubjectManagement.create(class_division_id:  @class_division.id, 
          account_id: @teacher.id,        
          subject_id:subject.id        
        )
        get :index, params: { token: @token, class_division: @class_division }
        expect(response).to have_http_status(200)
      end

      it 'returns a successful response with only class_division filter' do
        @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
        student = FactoryBot.create(:account, first_name: 'STD', role_id: @role.id, class_division_id: @class_division.id, activated: true)
        subject = BxBlockCatalogue::Subject.create(subject_name: 'abc', class_division_id: @class_division.id)
        subject_management = BxBlockCatalogue::SubjectManagement.create(
          class_division_id: @class_division.id,
          account_id: @teacher.id,
          subject_id: subject.id
        )
    
        get :index, params: { token: @token, class_division: @class_division.division_name }
    
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #student find' do

      it 'returns the student details with valid ID and class division' do
        @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
        @account = FactoryBot.create(:account, student_unique_id: 'ST345', role_id: @role.id, class_division_id: @class_division.id, activated: true)

        get :student_find, params: { id: 'ST345', token: @token  }

        json_data = JSON.parse(response.body)
        expect(response).to have_http_status(422)
      end

      it 'returns the student details with valid ID and class division' do
        @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
        account = FactoryBot.create(:account, student_unique_id: 'ST345', role_id: @role.id, class_division_id: @class_division.id, activated: true)

        get :student_find, params: { id: account.id, token: @token  }

        json_data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
      end
    end
  it 'returns a list of bundles' do
    ebook1 = FactoryBot.create(:ebook)
    bundle = FactoryBot.create(:bundle_management, ebooks: [ebook1] )

    get :show_bundle, params: { token: @token }

    json_data = JSON.parse(response.body)
    expect(response).to have_http_status(:ok)
  end

  it 'returns a nil ' do
    allow(BxBlockBulkUploading::BundleManagement).to receive(:all).and_return([])

    get :show_bundle, params: { token: @token }

    json_data = JSON.parse(response.body)
    expect(response).to have_http_status(422)
  end

  it 'returns a list of ebooks based on subject and search term' do
    ebook1 = FactoryBot.create(:ebook, title: 'Maths Book', subject: 'Math', author: 'John Doe')
    ebook2 = FactoryBot.create(:ebook, title: 'Science Book', subject: 'Science', author: 'Jane Doe')
    ebook3 = FactoryBot.create(:ebook, title: 'History Book', subject: 'History', author: 'Bob Smith')

    get :show_ebooks, params: { token: @token, subject: 'Math', search_term: 'John' }

    json_data = JSON.parse(response.body)
    expect(response).to have_http_status(:ok)
    expect(json_data['data'].length).to eq(1)
    expect(json_data['data'][0]['attributes']['title']).to eq('Maths Book')
  end

  it 'returns an empty list if no matching books are found' do
    get :show_ebooks, params: { token: @token, subject: 'Nonexistent Subject', search_term: 'Nonexistent Author' }

    json_data = JSON.parse(response.body)
    expect(response).to have_http_status(:not_found)
    expect(json_data['error']).to eq('No matching books found.')
  end

  it 'returns unauthorized for invalid user type' do
    role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Publisher')
    account = FactoryBot.create(:account, first_name: 'ST345', email:"a@yopmail.com", full_phone_number:"1254789565", role_id: role.id, activated: true)
    token = BuilderJsonWebToken::JsonWebToken.encode(account.id)
    ebook1 = FactoryBot.create(:ebook)
    bundle = FactoryBot.create(:bundle_management, ebooks: [ebook1] )

    get :show_bundle, params: { token: token }

    expect(response).to have_http_status(:unauthorized)
  end

  describe '#show_one_book' do
    it 'returns a successful response' do
      ebook = FactoryBot.create(:ebook)

      get :show_one_book_details, params: { id: ebook.id, token: @token }

      expect(response).to have_http_status(:ok)
    end
  end  

  describe 'GET #student_assigned_ebook_index' do
    before do
      @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
      @student = FactoryBot.create(:account, role_id: @role.id, class_division_id: @class_division.id, activated: true)
      ebook1 = create(:ebook, title: 'Book 1', subject: 'Math')
      ebook2 = create(:ebook, title: 'Book 2', subject: 'Science')
      create(:ebook_allotment, student: @student, ebook: ebook1, account: @teacher, alloted_date: Date.today)
      create(:ebook_allotment, student: @student, ebook: ebook2, account: @teacher, alloted_date: Date.today)
    end

    it 'returns a successful response with all ebooks when no subject filter is provided' do
      get :student_assigned_ebook_index, params: { id: @student.id, token: @token }

      expect(response).to have_http_status(:ok)
    end

    it 'returns a successful response with filtered ebooks when a subject filter is provided' do
      get :student_assigned_ebook_index, params: { id: @student.id, subject: 'Math', token: @token }
    
      expect(response).to have_http_status(:success)
      
      json_response = JSON.parse(response.body)
    end
  end

  describe 'GET #student_assigned_assignment_index' do
    it 'returns a list of assignments for the given student' do
      @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
      student = FactoryBot.create(:account, role_id: @role.id, class_division_id: @class_division.id, activated: true)
  
      get :student_assigned_assignment_index, params: { id: student.id, token: @token }

      expect(response).to have_http_status(:success)
    end

    it 'returns a list of assignments for the given student with subject filter' do
      @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
      student = FactoryBot.create(:account, role_id: @role.id, class_division_id: @class_division.id, activated: true)

      subject = BxBlockCatalogue::Subject.create(subject_name: "abc", class_division_id: @class_division.id )
      subject_management = BxBlockCatalogue::SubjectManagement.create(class_division_id:  @class_division.id, account_id: @teacher.id, subject_id:subject.id )

      get :student_assigned_assignment_index, params: { id: student.id, token: @token, subject: 'Mathematics' }

      expect(response).to have_http_status(:success)
    end
  end

  describe '#student_assigned_video_index' do
    it 'returns videos data without subject filter' do
      @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
      student = FactoryBot.create(:account, role_id: @role.id, class_division_id: @class_division.id, activated: true)
      
      get :student_assigned_video_index, params: { id: student.id, token: @token }

      expect(response).to have_http_status(:ok)
    end

    it 'returns videos data with subject filter' do
      @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
      student = FactoryBot.create(:account, role_id: @role.id, class_division_id: @class_division.id, activated: true)
      subject = BxBlockCatalogue::Subject.create(subject_name: "abc", class_division_id: @class_division.id )
      subject_management = BxBlockCatalogue::SubjectManagement.create(class_division_id:  @class_division.id, 
        account_id: @teacher.id,        
        subject_id:subject.id        
      )
      get :student_assigned_video_index, params: { id: student.id, token: @token, subject: 'Math' }

      expect(response).to have_http_status(:ok)
    end
    
    it 'returns an empty list if no videos found with subject filter' do
      @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
      student = FactoryBot.create(:account, role_id: @role.id, class_division_id: @class_division.id, activated: true)

      get :student_assigned_video_index, params: { id: student.id, token: @token, subject: 'NonexistentSubject' }

      expect(response).to have_http_status(:ok)
    end
  end
  
  describe '#list_subject' do
    context 'when subjects are present' do
      it 'returns a JSON response with subjects and status code 200' do
        subject1 = BxBlockCatalogue::Subject.create(subject_name: "abc", class_division_id: @class_division.id )
        subject2 = BxBlockCatalogue::Subject.create(subject_name: "abc", class_division_id: @class_division.id )

        allow(BxBlockCatalogue::Subject).to receive(:all).and_return([subject1, subject2])

        get :list_subject, params: { token: @token }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when subjects are not present' do
      it 'returns a JSON response with an error message and status code 404' do
        allow(BxBlockCatalogue::Subject).to receive(:all).and_return([])

        get :list_subject, params: { token: @token }

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET #class_listing' do
    it 'returns a list of school classes when available' do

      get :class_listing, params: { token: @token }

      expect(response).to have_http_status(:ok)
    end

    it 'returns an error when no school classes are found' do
      @school_class.destroy

      get :class_listing, params: { token: @token }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET #division_listing' do
    it 'returns a list of divisions when available' do

      get :division_listing, params: { token: @token }

      expect(response).to have_http_status(:ok)
    end
  end

end