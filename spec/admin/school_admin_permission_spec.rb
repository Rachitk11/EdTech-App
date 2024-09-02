require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers
RSpec.describe Admin::SchoolAdminsPermissionsController, type: :controller do
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

  
  describe "get#show" do
    it "return  specific school admin" do
      get :show, params: {id: @school_admin.id}
      expect(response).to have_http_status(200)
    end
  end
end