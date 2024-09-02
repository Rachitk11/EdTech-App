require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers
RSpec.describe Admin::SchoolAdminAnalyticsController, type: :controller do
	include Devise::Test::ControllerHelpers
	render_views
	before(:each) do
		@admin = AdminUser.find_or_create_by(email: "superadmin@example.com")
		@admin.role = "super_admin"
		@admin.password = "password"
		@admin.save
		sign_in @admin
		@role = BxBlockRolesPermissions::Role.find_or_create_by(name: "Publisher")
		@publisher = FactoryBot.create(:account, role_id: @role.id, full_phone_number: "7988896478", bank_account_number: "987876765656", ifsc_code: "PUBL29087")
	end

	describe "Total Publisher" do
		it "return publishers" do
			get :index
			expect(response).to have_http_status(200)
		end
	end
end