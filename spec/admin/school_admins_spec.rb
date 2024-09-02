require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers
RSpec.describe Admin::SchoolAdminsController, type: :controller do
	include Devise::Test::ControllerHelpers
	render_views
	
	before(:each) do
		@admin = AdminUser.find_or_create_by(email: "superadmin@example.com")
		@admin.role = "super_admin"
		@admin.password = "password"
		@admin.save
		sign_in @admin
		@role = BxBlockRolesPermissions::Role.find_or_create_by(name: "School Admin")
		@school = FactoryBot.create(:school, name: "svm school 23", phone_number: "8767656546")
		@school_admin = FactoryBot.create(:account, role_id: @role.id, school_id: @school.id, full_phone_number: "7988896478")
	end

	describe "get#index" do
		it "return school admins" do
			get :index
			expect(response).to have_http_status(200)
		end
	end

	describe "delete#destroy" do
		it "destroy record" do
			delete :destroy, params:{id: @school_admin.id}
			expect(response).to have_http_status(302)
		end
	end

	describe "get#show" do
		it "return  specific school admin" do
			get :show, params: {id: @school_admin.id}
			expect(response).to have_http_status(200)
		end
	end

	describe "update" do
		it "when update record" do
			put :update, params: {id: @school_admin.id, account: {first_name: "edutech", last_name: "app", email: "edutech@gmail.com", role_id: @role.id, school_id: @school.id, full_phone_number: "8767656545"} }
			expect(response).to have_http_status(302)
		end
	end

	describe "get#create" do
		it "create new record" do
			post :new, params: {first_name: "edutech", last_name: "app", email: "edutech@gmail.com", role_id: @role.id, school_id: @school.id, full_phone_number: "8767656545"}
			expect(response).to have_http_status(200)
		end
	end

	describe 'after_create callback' do
		it 'after_create callback' do
			post :create, params: { account: {first_name: "school_edutech", last_name: "school", email: "school16@gmail.com", role_id: @role.id, school_id: @school.id,full_phone_number: "8767658765"} }
		end
  end
end