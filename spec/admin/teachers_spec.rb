require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers
RSpec.describe Admin::TeachersController, type: :controller do
	include Devise::Test::ControllerHelpers
	render_views
	
	before(:each) do
  @admin = AdminUser.find_or_create_by(email: "superadmin@example.com")
  @admin.role = "super_admin"
  @admin.password = "password"
  @admin.save
  sign_in @admin
  @role = BxBlockRolesPermissions::Role.find_or_create_by(name: "Teacher")
  @school = FactoryBot.create(:school, name: "BGPSS", phone_number: 9087654999)
  @teacher1 = FactoryBot.create(:account, role_id: @role.id, school_id: @school.id)
  @class_division = FactoryBot.create(:class_division, school_class_id: nil, school_id: @school.id ,account_id: @teacher1.id)
  @school_class = FactoryBot.create(:school_class, school_id: @school.id, class_divisions: [@class_division] )
  # @department = FactoryBot.create(:department, school_id: @school.id, school_class_id: @school_class.id)
  # @class_division = FactoryBot.create(:class_division, school_class_id: @school_class.id, school_id: @school.id,account_id: @teacher1.id)
  @teacher = FactoryBot.create(
    :account,
    role_id: @role.id,
    school_id: @school.id,
    school_class_id: @school_class.id,
    class_division_id: @class_division.id
  )
end

	describe "get#index" do
		it "return teachers" do
			get :index
			expect(response).to have_http_status(200)
		end
	end

	describe "delete#destroy" do
		it "destroy record" do
			delete :destroy, params:{id: @teacher1.id}
			expect(response).to have_http_status(302)
		end
	end

	describe "get#show" do
		it "return  specific teacher" do
			get :show, params: {id: @teacher1.id}
			expect(response).to have_http_status(200)
		end
	end

	describe "get#create" do
		it "create new record" do
			post :new, params: {first_name: "edutech", last_name: "app", email: "edutech1@gmail.com", teacher_unique_id: "teacher_03", role_id: @role.id, school_id: @school.id, full_phone_number: "8767656545", school_class_id: @school_class.id,class_division_id: @class_division.id}
			expect(response).to have_http_status(200)
		end

		it "create new record" do
			post :create, params: {account: {first_name: "edutech", last_name: "app", email: "edutech2@gmail.com", teacher_unique_id: "teacher_03", role_id: @role.id, school_id: @school.id, full_phone_number: "8767656545", school_class_id: @school_class.id,class_division_id: @class_division.id} }

			expect(response).to have_http_status(302)
		end
	end

	describe "update" do

		it "when update record" do
			put :edit, params: {id: @teacher.id, account: {first_name: "edutech", last_name: "app", email: "edutech3@gmail.com", teacher_unique_id: "teacher_03", role_id: @role.id, school_id: @school.id, full_phone_number: "8767656545", school_class_id: @school_class.id,class_division_id: @class_division.id} }
			expect(response).to have_http_status(200)
		end

		it "when update record" do
			put :update, params: {id: @teacher.id, account: {first_name: "edutech", last_name: "app", email: "edutech43@gmail.com", teacher_unique_id: "teacher_03", role_id: @role.id, school_id: @school.id, full_phone_number: "8767656545", school_class_id: @school_class.id,class_division_id: @class_division.id} }
			expect(response).to have_http_status(302)
		end
	end

	describe 'after_create callback' do
		it 'after_create callback' do
			post :create, params: { account: {first_name: "teacher_edutech", last_name: "teacher", email: "guardian163@gmail.com", role_id: @role.id, school_id: @school.id, teacher_unique_id: "teacher_06", full_phone_number: "8767656598", school_class_id: @school_class.id,class_division_id: @class_division.id} }
		end
  end
end