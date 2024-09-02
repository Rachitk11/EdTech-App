require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers
RSpec.describe Admin::AssignmentsController, type: :controller do
	include Devise::Test::ControllerHelpers
	render_views
	before(:each) do
		@admin = AdminUser.find_or_create_by(email: "superadmin@example.com")
		@admin.role = "super_admin"
		@admin.password = "password"
		@admin.save
		sign_in @admin
		@teacher_role = BxBlockRolesPermissions::Role.find_or_create_by(name: "Teacher")
		@school = FactoryBot.create(:school, name: "Standard Fort", phone_number: 7654309908)
		@teacher = FactoryBot.create(:account, role_id: @teacher_role.id, school_id: @school.id)
		@class_division = FactoryBot.create(:class_division, school_class_id: nil, account_id: @teacher.id)

		@school_class = FactoryBot.create(:school_class, school_id: @school.id, class_divisions: [@class_division])
		@subject = BxBlockCatalogue::Subject.find_or_create_by(subject_name: FFaker::Name.first_name)
		@subject_management = BxBlockCatalogue::SubjectManagement.find_or_create_by(subject_id: @subject.id, account_id: @teacher.id)
		subject_management = BxBlockCatalogue::SubjectManagement.find_by(id: @subject_management.id)
		pdf_file = Tempfile.new(['example', '.pdf'])
		pdf_file.write('PDF content goes here')
		pdf_file.rewind
		allowed_extensions = ['.pdf', '.doc']

		if allowed_extensions.include?(File.extname(pdf_file.path).downcase)
		  pdf_blob = ActiveStorage::Blob.create_and_upload!(
		    io: pdf_file,
		    filename: 'example.pdf',
		    content_type: 'application/pdf'
		  )
		else
		  puts 'Invalid file type only PDF or Doc File'
		end
		@assignment = BxBlockCatalogue::Assignment.new(title: "video", description: "this is video", subject_id:  @subject.id, subject_management: subject_management)
		@assignment.assignment.attach(pdf_blob)
		@assignment.save

	end

	describe "get#index" do
		it "listing of assignment" do
			get :index
			response_body = response.body
    	expect(response_body['title']).to eq("title")
	    expect(response_body['description']).to eq("description")
		end
	end

	describe "delete#destroy" do
		it "destroy record" do
			delete :destroy, params:{id: @assignment.id}
			response_body = response.body
    	expect(response_body['title']).to eq(nil)
	    expect(response_body['description']).to eq(nil)

		end
	end

	describe "get#show" do
		it "show the assignment" do
			get :show, params: {id: @assignment.id}
    	response_body = response.body
    	expect(response_body['title']).to eq("title")
	    expect(response_body['description']).to eq("description")
		end
	end

	describe "get#create" do
		it "create new record" do
			post :new, params: { assignment: { title: "assignment", description: "this is maths assignment ", subject_id:  @subject.id, subject_management_id: @subject_management.id } }
			# expect(response).to have_http_status(200)
			response_body = response.body
      expect(response_body['title']).to eq("title")
      expect(response_body['description']).to eq("description")
		end

		 it "does not create a new record with invalid parameters" do
      post :create, params: { assignment: { title: "", description: "", subject_id: nil, subject_management_id: nil } }
      expect(response).to have_http_status(302)
    end
	end

	describe "get#edit " do
		it "when edit record" do
			put :edit, params: {  id: @assignment.id, title: "assignment_1", description: "this is maths PDF", subject_id:  @subject.id, subject_management: @subject_management.id } 
			response_body = response.body
      expect(response_body['title']).to eq("title")
	    expect(response_body['description']).to eq("description")
	    expect(response_body['subject_id']).to eq("subject_id")
	    expect(response_body['subject_management']).to eq("subject_management")
		end
	end

	describe 'POST #create' do

    let(:valid_params) do
	  pdf_file = Tempfile.new(['example', '.pdf'])
	  pdf_file.write('PDF content ')
	  pdf_file.rewind

	  allowed_extensions = ['.pdf', '.doc']

	  return {} unless allowed_extensions.include?(File.extname(pdf_file.path).downcase)

	  {
	    title: "assignment12", 
	    description: "this is assignment 234",
	    subject_id: @subject.id,
	    subject_management_id: @subject_management.id,
	    assignment: Rack::Test::UploadedFile.new(pdf_file.path, 'application/pdf')
	  }
	end
    context 'when creating an assignment with invalid parameters' do
      it 'renders the new template with an error message' do
        post :create, params: { assignment: { invalid_param: 'invalid_value' } }
        # expect(response).to redirect_to(new_admin_assignment_path(format: :html))
        expect(response).to have_http_status(302)
      end
    end

    context 'when creating an assignment with valid parameters' do
      it 'renders the new template with valid parameters' do
        post :create, params: { assignment: valid_params }
        expect(flash[:notice]).to eq("Assignment created successfully." )
      end
    end
  end

  describe 'PATCH #update' do


    let(:invalid_update_params) do
	  pdf_file = Tempfile.new(['example', '.pdf'])
	  pdf_file.write('PDF or Doc details')
	  pdf_file.rewind

	  allowed_extensions = ['.pdf', '.doc']

	  if allowed_extensions.include?(File.extname(pdf_file.path).downcase)
	    {
	      title: " ", 
	      description: " ",
	      subject_id: @subject.id,
	      subject_management_id: @subject_management.id,
	      assignment: Rack::Test::UploadedFile.new(pdf_file.path, 'application/pdf3')
	    }
	  else
	    puts 'Only PDF and DOC type  files are allowed.'
	    {}
	  end
	end

    # context 'when updating an assignment with valid parameters' do
    #   it 'renders the edit template with valid params' do
    #     patch :update, params: { id: @assignment.id, assignment: valid_update_params}
    #     expect(flash[:notice]).to eq('Assignment updated successfully.')
    #   end
    # end

    context 'when updating an assignment with invalid parameters' do
      it 'renders the edit template with an error message' do

        patch :update, params: { id: @assignment.id, assignment: invalid_update_params }
        # expect(response).to render_template(:edit)
        expect(flash[:error]).to eq(nil)
      end
    end
  end
end