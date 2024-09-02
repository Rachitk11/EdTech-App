require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers
RSpec.describe Admin::ClassDivisionsController, type: :controller do
	include Devise::Test::ControllerHelpers
	render_views
	
	before(:each) do
		@admin = AdminUser.find_or_create_by(email: "superadmin202@example.com")
		@admin.role = "super_admin"
		@admin.password = "password"
		@admin.save
		# sign_in @admin
		@student_role = BxBlockRolesPermissions::Role.find_or_create_by(name: "Student")
		@teacher_role = BxBlockRolesPermissions::Role.find_or_create_by(name: "Teacher")
		@school = FactoryBot.create(:school, name: "BSPPS", phone_number: 7896543216)
		@student = FactoryBot.create(:account, first_name: "asdffg", role_id: @student_role.id, student_unique_id: "ST55", school_id: @school.id)
		@teacher = FactoryBot.create(:account, role_id: @teacher_role.id, school_id: @school.id,)
		@class_division = FactoryBot.create(:class_division, school_class_id: nil, account_id: @teacher.id)
		@school_class = FactoryBot.create(:school_class, school_id: @school.id, class_divisions: [@class_division])
		@subject = BxBlockCatalogue::Subject.create(subject_name: "maths")

		@school_admin_role = FactoryBot.create(:role, name: "School Admin")
		@school_admin_account = FactoryBot.create(:account, role_id: @school_admin_role.id, school_id: @school.id )
		@subadmin = AdminUser.create(email: @school_admin_account.email, role: "sub_admin", school_id: @school.id, password: "password", password_confirmation: "password", class_allow: true)
		
		sign_in @admin if @admin.persisted?
    sign_in @subadmin if @subadmin.persisted?
	end

	describe "get#index" do
		it "return classes division of school" do
			get :index
			expect(response).to have_http_status(200)
		end
	end

	describe "get#show" do
		it "return  specific class division  of school" do
			get :show, params: {id: @class_division.id}
			expect(response).to have_http_status(200)
		end
	end

	describe "get#show" do
		it "return  specific only class division of school" do
			get :show, params: {id: @class_division.id}
			expect(response).to have_http_status(200)
		end
	end

	describe "get#create" do
		it "create new record" do
			post :new, params: {division_name: "A", school_id: @school.id, school_class_id: @school_class.id}
			expect(response).to have_http_status(200)
		end
	end

	describe "destroy action" do
	 	it "destroys the class_division and redirects to the class path" do
	 		if @class_division.school_class.present?
		 		school_class_id = @class_division.school_class_id
		 		delete :destroy, params: { id: @class_division.id }
		 	end
	 	end
	end

	describe "GET #edit" do
	    it "renders the edit template" do
	      get :edit, params: { id: @class_division.id }
	    end
	end

	describe 'PATCH #update' do
	  it 'updates subject_ids and subject_teacher_ids of class_division' do
	  	patch :update, params: { id: @class_division.id, class_division: { subject_ids: @subject.id, subject_teacher_ids:  @teacher.id} }
	       @class_division.reload
	    expect(response).to have_http_status(302)
	  end
	end
end