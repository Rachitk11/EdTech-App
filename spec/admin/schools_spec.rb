require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers
RSpec.describe Admin::SchoolsController, type: :controller do
	include Devise::Test::ControllerHelpers
	render_views
	before(:each) do
		@admin = AdminUser.find_or_create_by(email: "superadmin@example.com")
		@admin.role = "super_admin"
		@admin.password = "password"
		@admin.save
		# school = FactoryBot.create(:school, phone_number: 1234512309)
		# @subadmin = AdminUser.find_or_create_by(email: "subadmin11@example.com")
		# @subadmin.role = "sub_admin"
		# @subadmin.school_id = school.id
		# @subadmin.password = "password"
		# @subadmin.save
		sign_in @admin
		# sign_in @admin if @admin.persisted?
        # sign_in @subadmin if @subadmin.persisted?
		@school = FactoryBot.create(:school, name: "Fatherson Public School", phone_number: "8767656545")
	end

	describe "get#index" do
		it "return schools" do
			get :index
			expect(response).to have_http_status(200)
		end
	end

	describe "get#show" do
		it "return  specific school" do
			get :show, params: {id: @school.id}
			expect(response).to have_http_status(200)
		end
	end

	describe "get#create" do
		it "create new record" do
			post :new, params: {first_name: "edutech", last_name: "app", email: "edutech@gmail.com", guardian_email: "guardian123@gmail.com", user_type: "Student", full_phone_number: "8767656545"}
			expect(response).to have_http_status(200)
		end
	end

	describe "destroy action" do
	 	it "destroys the school" do
	 		if @school.present?
		 		delete :destroy, params: { id: @school.id }
		 	end
	 	end
	end
end