require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers
RSpec.describe Admin::StudentsController, type: :controller do
	include Devise::Test::ControllerHelpers
	render_views
	
	before(:each) do
	  @admin = AdminUser.find_or_create_by(email: "superadmin@example.com")
	  @admin.role = "super_admin"
	  @admin.password = "password"
	  @admin.save
	  sign_in @admin
	  @role = BxBlockRolesPermissions::Role.find_or_create_by(name: "Student")
	  @teacher_role = BxBlockRolesPermissions::Role.find_or_create_by(name: "Teacher")
	  @school = FactoryBot.create(:school, name: "BGPS", phone_number: 7890654321)
	  # @school_class = FactoryBot.create(:school_class, school_id: @school.id)
	  @teacher = FactoryBot.create(:account, role_id: @teacher_role.id, school_id: @school.id)
	  @class_division = FactoryBot.create(:class_division, school_class_id: nil, account_id: @teacher.id)
		@school_class = FactoryBot.create(:school_class, school_id: @school.id, class_divisions: [@class_division])
	  @student = FactoryBot.create(
	    :account,
	    role_id: @role.id,
	    student_unique_id: "ST557",
	    school_id: @school.id,
	    school_class_id: @school_class.id,
	    class_division_id: @class_division.id
	  )
	end

	describe "get#index" do
		it "return students" do
			get :index
			expect(response).to have_http_status(200)
		end
	end

	describe "delete#destroy" do
		it "destroy record" do
			delete :destroy, params:{id: @student.id}
			expect(response).to have_http_status(302)
		end
	end

	describe "get#show" do
		it "return  specific student" do
			get :show, params: {id: @student.id}
			expect(response).to have_http_status(200)
		end
	end

	describe "get#create" do
		it "create new record" do
			post :new, params: {first_name: "edutech", guardian_email: "guardian123@gmail.com", role_id: @role.id, school_id: @school.id, student_unique_code: "8787", full_phone_number: "8767656545", school_class_id: @school_class.id,class_division_id: @class_division.id}

			expect(response).to have_http_status(200)
		end

		it "create new record" do
			post :create, params: {account: {first_name: "edutech", guardian_email: "guardian109@gmail.com", role_id: @role.id, school_id: @school.id, student_unique_code: "8787", full_phone_number: "8767656545", school_class_id: @school_class.id,class_division_id: @class_division.id} }

			expect(response).to have_http_status(302)
		end
	end

	describe "update" do

		it "when update record" do
			put :edit, params: {id: @student.id, account: {first_name: "edutech", guardian_email: "guardian9@gmail.com", role_id: @role.id, school_id: @school.id, student_unique_code: "8787", full_phone_number: "8767656545", school_class_id: @school_class.id,class_division_id: @class_division.id} }
			expect(response).to have_http_status(200)
		end

		it "when update record" do
			put :update, params: {id: @student.id, account: {first_name: "edutech", guardian_email: "guard3@gmail.com", role_id: @role.id, school_id: @school.id, student_unique_code: "8787", full_phone_number: "8767656545", school_class_id: @school_class.id,class_division_id: @class_division.id} }
			expect(response).to have_http_status(302)
		end
	end

	describe 'after_create callback' do
		it 'after_create callback' do
			post :create, params: { account: {first_name: "edutech1", guardian_email: "guar3@gmail.com", role_id: @role.id, school_id: @school.id, student_unique_code: "8587", full_phone_number: "8767656547", school_class_id: @school_class.id,class_division_id: @class_division.id} }
		end
  end
end