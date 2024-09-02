require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers
RSpec.describe Admin::SubjectAndTeachersController, type: :controller do
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
		@subject = BxBlockCatalogue::Subject.create(subject_name: FFaker::Name.first_name)
		@subject_management = BxBlockCatalogue::SubjectManagement.create(subject_id: @subject.id, account_id: @teacher.id, class_division_id: @class_division.id)
	
		@school_admin_role = FactoryBot.create(:role, name: "School Admin")
		@school_admin_account = FactoryBot.create(:account, role_id: @school_admin_role.id, school_id: @school.id )
		@subadmin = AdminUser.create(email: @school_admin_account.email, role: "sub_admin", school_id: @school.id, password: "password", password_confirmation: "password", subject_allow: true)
		
		sign_in @admin if @admin.persisted?
        sign_in @subadmin if @subadmin.persisted?
	end

	describe "get#index" do
		it "listing of subject" do
			get :index
			expect(response).to have_http_status(200)
		end
	end

	describe "delete#destroy" do
		it "destroy record" do
			delete :destroy, params:{id: @subject_management.id}
			expect(response).to have_http_status(302)
		end
	end

	describe "get#show" do
		it "show the subject" do
			get :show, params: {id: @subject_management.id}
			expect(response).to have_http_status(200)
		end
	end

	describe "get#create" do
		it "create new record" do
			post :new, params: { subject_id: @subject.id, account_id: @teacher.id }
			expect(response).to have_http_status(200)
		end
	end
end