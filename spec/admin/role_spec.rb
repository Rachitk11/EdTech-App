require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers
RSpec.describe Admin::RolesController, type: :controller do
	include Devise::Test::ControllerHelpers
	render_views
	
	before(:each) do
		@admin = AdminUser.find_or_create_by(email: "superadmin@example.com")
		@admin.role = "super_admin"
		@admin.password = "password"
		@admin.save
		sign_in @admin
		@role = FactoryBot.create(:role, name: "Role")
	end

	describe "get#index" do
		it "return roles" do
			get :index
			expect(response).to have_http_status(200)
		end
	end

	describe "get#show" do
		it "return  specific role" do
			get :show, params: {id: @role.id}
			expect(response).to have_http_status(200)
		end
	end

	describe "delete#destroy" do
		it "destroy record" do
			delete :destroy, params:{id: @role.id}
			expect(response).to have_http_status(302)
		end
	end

	# describe "get#create" do
	# 	it "create new role" do
	# 		post :new, params: {name: "Student"}
	# 		expect(response).to have_http_status(200)
	# 	end
	# end
end