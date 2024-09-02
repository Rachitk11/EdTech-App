require 'rails_helper'

RSpec.describe BxBlockCatalogue::StudyMaterialsController, type: :controller do
  before(:each) do
  	@student_role = FactoryBot.create(:role, name: "Student")
    @teacher_role = FactoryBot.create(:role, name: "Teacher")
    @school_admin_role = FactoryBot.create(:role, name: "School Admin")
    @publisher_role =FactoryBot.create(:role, name: "Publisher")
    @school = FactoryBot.create(:school, name: "Standard Fort", phone_number: 7654309309)
    @school_admin_account = FactoryBot.create(:account, role_id: @school_admin_role.id, school_id: @school.id)
    @teacher = FactoryBot.create(:account, role_id: @teacher_role.id, teacher_unique_id: "TECH00055", school_id: @school.id)
    @class_division = FactoryBot.create(:class_division, school_class_id: nil, account_id: @teacher.id, division_name: "A", school_id: @school.id)
		@school_class = FactoryBot.create(:school_class, school_id: @school.id, class_divisions: [@class_division], class_number: 1)
		@subject = BxBlockCatalogue::Subject.find_or_create_by(subject_name: 'maths')
		@subject_management = BxBlockCatalogue::SubjectManagement.find_or_create_by(subject_id: @subject.id, account_id: @teacher.id)
		subject_management = BxBlockCatalogue::SubjectManagement.find_by(id: @subject_management.id)
    @student_account = FactoryBot.create(:account, role_id: @student_role.id , student_unique_id: "BGS", class_division_id: @class_division.id, school_class_id: @school_class.id, school_id: @school.id)
		@video = BxBlockCatalogue::VideosLecture.find_or_create_by(title: "video", description: "this is video", subject_id:  @subject.id, subject_management: subject_management, account_id: @teacher.id, class_division_id: @class_division.id, school_class_id: @school_class.id, video: "https://www.youtube.com/watch?v=t4R60Tc5nho", school_id: @school.id)

		pdf_file = Tempfile.new(['example', '.pdf'])
	  pdf_file.write('PDF content goes here') 
	  pdf_file.rewind

	  pdf_blob = ActiveStorage::Blob.create_and_upload!(
	    io: pdf_file,
	    filename: 'example.pdf',
	    content_type: 'application/pdf'
	  )
		@assignment = BxBlockCatalogue::Assignment.new(title: "video", description: "this is PDF", subject_id:  @subject.id, subject_management: subject_management, account_id: @teacher.id, class_division_id: @class_division.id, school_class_id: @school_class.id, school_id: @school.id)

		@assignment.assignment.attach(pdf_blob)
		@assignment.save
		@student_token = BuilderJsonWebToken.encode(@student_account.id)
    @teacher_token = BuilderJsonWebToken.encode(@teacher.id)
    @school_admin_token = BuilderJsonWebToken.encode(@school_admin_account.id)
    @ebook = FactoryBot.create(:ebook)
    @ebook_allotment = BxBlockBulkUploading::EbookAllotment.create(account_id: @teacher.id, student_id: @student_account.id, ebook_id: @ebook.id, alloted_date: Date.today, school_class_id: @school_class.id, class_division_id: @class_division.id, school_id: @school.id)
  end

  describe '#video_and_assignment_for_student' do
    it 'returns data for video type for student' do
      params =  { type: 'video', subject_name: 'maths', video_search: 'Algebra', token: @student_token } 
      get :video_and_assignment_for_student, params: params
      body = JSON.parse(response.body) 
      expect(response).to have_http_status :ok
    end

    it 'returns data for assignment type for student' do
      params = { type: 'assignment', subject_name: 'History' , token: @student_token }

      get :video_and_assignment_for_student, params: params
      body = JSON.parse(response.body)
      expect(response).to have_http_status :ok 
    end

    it 'returns data for student without any type' do
      params = { token: @student_token }

      get :video_and_assignment_for_student, params: params
      body = JSON.parse(response.body)
      expect(response).to have_http_status :ok 
    end

    it 'with unauthorized user in student' do
      params = { token: @school_admin_token }

      get :video_and_assignment_for_student, params: params
      body = JSON.parse(response.body)
      expect(response).to have_http_status(422)
    end
  end

  describe '#video_and_assignment_for_teacher' do
    it 'returns correct data for  type for teacher video' do
      params =  { type: 'video', school_class: @school_class.id, division: @class_division.id, token: @teacher_token } 
      get :video_and_assignment_for_teacher, params: params
      body = JSON.parse(response.body) 
      expect(response).to have_http_status :ok
    end

    it 'returns correct data for type for teacher video with only class id' do
      params =  { type: 'video', school_class: @school_class.id, token: @teacher_token } 
      get :video_and_assignment_for_teacher, params: params
      body = JSON.parse(response.body) 
      expect(response).to have_http_status :ok
    end

    it 'returns correct data for type for teacher assignment' do
      params = { type: 'assignment', school_class: @school_class.id, division: @class_division.id, token: @teacher_token }

      get :video_and_assignment_for_teacher, params: params
      body = JSON.parse(response.body)
      expect(response).to have_http_status :ok 
    end

    it 'returns correct data for type for teacher ebook' do
      params = { type: 'ebook', school_class: @school_class.id, division: @class_division.id, token: @teacher_token }

      get :video_and_assignment_for_teacher, params: params
      body = JSON.parse(response.body)
      expect(response).to have_http_status :ok 
    end

    it 'returns correct data for type for teacher assignment with only class id' do
      params = { type: 'assignment', school_class: @school_class.id, token: @teacher_token }

      get :video_and_assignment_for_teacher, params: params
      body = JSON.parse(response.body)
      expect(response).to have_http_status :ok 
    end

    it 'returns correct data for type for teacher ebook with only class id' do
      params = { type: 'ebook', school_class: @school_class.id, token: @teacher_token }

      get :video_and_assignment_for_teacher, params: params
      body = JSON.parse(response.body)
      expect(response).to have_http_status :ok 
    end

    it 'returns correct data for teacher without any type' do
      params = { token: @teacher_token }

      get :video_and_assignment_for_teacher, params: params
      body = JSON.parse(response.body)
      expect(response).to have_http_status :ok 
    end

    it 'with unauthorized user school admin' do
      params = { token: @school_admin_token }

      get :video_and_assignment_for_teacher, params: params
      body = JSON.parse(response.body)
      expect(response).to have_http_status(422)
    end
  end

  describe '#video_and_assignment_for_school_admin' do
    it 'write correct data for video type for school admin' do
      params =  { type: 'video', school_class: @school_class.id, division: @class_division.id, token: @school_admin_token } 
      get :video_and_assignment_for_school_admin, params: params
      body = JSON.parse(response.body) 
      expect(response).to have_http_status :ok
    end

    it 'write correct data for video type for school admin with only class id' do
      params =  { type: 'video', school_class: @school_class.id, token: @school_admin_token } 
      get :video_and_assignment_for_school_admin, params: params
      body = JSON.parse(response.body) 
      expect(response).to have_http_status :ok
    end

    it 'write correct data for type for school admin assignment ' do
      params = { type: 'assignment', school_class: @school_class.id, division: @class_division.id, token: @school_admin_token }

      get :video_and_assignment_for_school_admin, params: params
      body = JSON.parse(response.body)
      expect(response).to have_http_status :ok 
    end

    it 'write correct data for type for school admin assignment with only class id ' do
      params = { type: 'assignment', school_class: @school_class.id, token: @school_admin_token }

      get :video_and_assignment_for_school_admin, params: params
      body = JSON.parse(response.body)
      expect(response).to have_http_status :ok 
    end

    it 'write correct data for type for school admin ebook ' do
      params = { type: 'ebook', school_class: @school_class.id, division: @class_division.id, token: @school_admin_token }

      get :video_and_assignment_for_school_admin, params: params
      body = JSON.parse(response.body)
      expect(response).to have_http_status :ok 
    end

    it 'write correct data for type for school admin ebook with only class id ' do
      params = { type: 'ebook', school_class: @school_class.id, token: @school_admin_token }

      get :video_and_assignment_for_school_admin, params: params
      body = JSON.parse(response.body)
      expect(response).to have_http_status :ok 
    end

    it 'write correct data for type for school admin assignment with only class id ' do
      params = {token: @school_admin_token }

      get :video_and_assignment_for_school_admin, params: params
      body = JSON.parse(response.body)
      expect(response).to have_http_status :ok 
    end

    it 'with unauthorized in the school admin' do
      params = { token: @teacher_token }

      get :video_and_assignment_for_school_admin, params: params
      body = JSON.parse(response.body)
      expect(response).to have_http_status(422)
    end
  end


  describe 'Student details for video id ' do
    it 'write correct data of student details for video' do
      params =  { video_id: @video.id, token: @teacher_token } 
      get :student_details_video, params: params
      body = JSON.parse(response.body) 
      expect(response).to have_http_status :ok
    end
  end

  describe 'Student details for assignment id ' do
    it 'write correct data of student details for assignment' do
      params =  { assignment_id: @assignment.id, token: @teacher_token } 
      get :student_details_assignment, params: params
      body = JSON.parse(response.body) 
      expect(response).to have_http_status :ok
    end
  end

  describe 'Student details for ebook id ' do
    it 'write correct data of student details for ebook' do
      params =  { assign_ebook_id: @ebook_allotment.id, token: @teacher_token }
      get :student_details_ebook, params: params
      body = JSON.parse(response.body) 
      expect(response).to have_http_status :not_found
    end
  end

  describe 'Student details for ebook id' do
    it 'changes the student video lecture' do
      request.headers['token'] = @student_token
      post :update_video_status, params: { data: { video_id: @video.id } }
      body = JSON.parse(response.body) 
      expect(body["data"]["message"]).to eq ("Video lecture is completed")
      expect(response).to have_http_status(:ok)
    end

    it 'when video lecture is not found' do
      request.headers['token'] = @student_token
      post :update_video_status, params: { data: { video_id: 6 } } 
      body = JSON.parse(response.body) 
      expect(body["data"]["error"]).to eq ("Video not found")
      expect(response).to have_http_status(:not_found)
    end
  end

end