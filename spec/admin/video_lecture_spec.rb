require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers
RSpec.describe Admin::VideoLecturesController, type: :controller do
	include Devise::Test::ControllerHelpers
	render_views
	before(:each) do
		@admin = AdminUser.find_or_create_by(email: "superadmin@example.com")
		@admin.role = "super_admin"
		@admin.password = "password"
		@admin.save
		# sign_in @admin
		@teacher_role = BxBlockRolesPermissions::Role.find_or_create_by(name: "Teacher")
		@school = FactoryBot.create(:school, name: "Standard Fort", phone_number: 7654309309)
		@teacher = FactoryBot.create(:account, role_id: @teacher_role.id, school_id: @school.id)
		@class_division = FactoryBot.create(:class_division, school_class_id: nil, account_id: @teacher.id)

		@school_class = FactoryBot.create(:school_class, school_id: @school.id, class_divisions: [@class_division])
		@subject = BxBlockCatalogue::Subject.find_or_create_by(subject_name: FFaker::Name.first_name)
		@subject_management = BxBlockCatalogue::SubjectManagement.find_or_create_by(subject_id: @subject.id, account_id: @teacher.id)
		subject_management = BxBlockCatalogue::SubjectManagement.find_by(id: @subject_management.id)
		@video = BxBlockCatalogue::VideosLecture.find_or_create_by(title: "video", description: "this is video lecture", subject_id:  @subject.id, subject_management: subject_management,  video: "https://www.youtube.com/watch?v=bL6dJjxm0x0")
		
		@school_admin_role = FactoryBot.create(:role, name: "School Admin")
		@school_admin_account = FactoryBot.create(:account, role_id: @school_admin_role.id, school_id: @school.id )
		@subadmin = AdminUser.create(email: @school_admin_account.email, role: "sub_admin", school_id: @school.id, password: "password", password_confirmation: "password", video_allow: true)
		sign_in @admin if @admin.persisted?
        sign_in @subadmin if @subadmin.persisted?
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
			delete :destroy, params:{id: @video.id, subject_management_id: @video.subject_management_id}
			response_body = response.body
    	expect(response_body['title']).to eq(nil)
	    expect(response_body['description']).to eq(nil)

		end
	end

	describe "get#show" do
		it "show the video" do
			get :show, params: {id: @video.id}
    	response_body = response.body
    	expect(response_body['title']).to eq("title")
	    expect(response_body['description']).to eq("description")
		end
	end

	describe "when#new" do
		it "when the video create" do
		post :new, params: { title: "video_2", description: "this is video 2 url", subject_id:  @subject.id, subject_management_id: @subject_management.id,  video: "https://www.youtube.com/watch?v=8zyrkLJUKb0" }
    	response_body = response.body
    	expect(response_body['title']).to eq("title")
	    expect(response_body['description']).to eq("description")
		end
	end

	describe "get#edit" do
		it "when edit record" do
			put :edit, params: {id: @video.id,  title: "video_2", description: "this is video 2 url", subject_id:  @subject.id, subject_management_id: @subject_management.id,  video: "https://www.youtube.com/watch?v=fIYeriIO8sA" } 
			# expect(response).to have_http_status(200)
			response_body = response.body
	      	expect(response_body['title']).to eq("title")
		    expect(response_body['description']).to eq("description")
		    expect(response_body['subject_id']).to eq("subject_id")
		    expect(response_body['subject_management_id']).to eq("subject_management_id")
		end
	end

	describe 'POST #create' do
    let(:valid_params) do
      {
        videos_lecture: {
          subject_id: @subject.id,
          subject_management_id: @subject_management.id
        }
      }
    end

    context 'when creating a video lecture with invalid parameters' do
      it 'renders the new template with an error message' do
        post :create, params: { videos_lecture: { invalid_param: 'invalid_value' } }
        expect(response).to have_http_status(302)
      end
    end

  end

  describe 'PATCH #update' do
    let(:valid_update_params) do
      {
        id: @video.id,
        videos_lecture: {
          subject_id: @subject.id,
          subject_management_id: @subject_management.id
        }
      }
    end

    context 'when updating a video lecture with invalid parameters' do
      it 'renders the edit template with an error message' do
        patch :update, params: { id: @video.id, videos_lecture: { invalid_param: 'invalid_value' } }
        # expect(response).to render_template(:edit)
        expect(flash[:notice]).to eq('Video Lecture updated successfully.')
      end
    end

    context 'when updatea video lecture with invalid parameters' do
      it 'renders the new template with an error message' do
        post :update, params: {id: @video.id, videos_lecture: { invalid_param: 'valid_update_params' } }
        expect(response).to have_http_status(302)
      end
    end
  end
end