require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers
RSpec.describe Admin::DashboardController, type: :controller do
	include Devise::Test::ControllerHelpers
	render_views
	before(:each) do
		@admin = AdminUser.find_or_create_by(email: "superadmin@example.com")
		@admin.role = "super_admin"
		@admin.role = "super_admin"
		@admin.password = "password"
		@admin.save
		# sign_in @admin
		@school = FactoryBot.create(:school, name: "BSPPS", phone_number: 7654321389)
		@subadmin = AdminUser.find_or_create_by(email: "subadmin11@example.com")
		@subadmin.role = "sub_admin"
		@subadmin.school_id = @school.id
		@subadmin.password = "password"
		@subadmin.save
		 sign_in @admin if @admin.persisted?
         sign_in @subadmin if @subadmin.persisted?
		@role = BxBlockRolesPermissions::Role.find_or_create_by(name: "Publisher")
		@publisher = FactoryBot.create(:account, role_id: @role.id, full_phone_number: "7988896478", bank_account_number: "987876765656", ifsc_code: "PUBL29087")
		@teacher_role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Teacher')
	  @teacher = FactoryBot.create(:account, role_id: @teacher_role.id, school_id: @school.id)
	end

	describe "GET #index" do
    context "as a super admin" do
      before do
        sign_in @admin
        get :index
      end

      it "responds successfully" do
        expect(response).to have_http_status(200)
      end

      it "displays total students" do
        expect(response.body).to include("Total Students")
        expect(response.body).to include(AccountBlock::Account.joins(:role).where(roles: {name: "Student"}).count.to_s)
      end

      it "displays total school admins" do
        expect(response.body).to include("Total School Admins")
      end

      it "displays total teachers" do
        expect(response.body).to include("Total Teachers")
      end

      it "displays total ebooks" do
        expect(response.body).to include("Total Ebooks")
      end

      it "displays total ebook bundles" do
        expect(response.body).to include("Total Ebook Bundles")
      end
    end

    context "as a school admin" do
      before do
        sign_in @subadmin
        get :index
      end

      it "responds successfully" do
        expect(response).to have_http_status(200)
      end

      it "displays total students for the school" do
        expect(response.body).to include("Total Students")
        expect(response.body).to include(AccountBlock::Account.where(school_id: @school.id).joins(:role).where(roles: { name: "Student" }).count.to_s)
      end

      it "displays total teachers for the school" do
        expect(response.body).to include("Total Teacher")
        expect(response.body).to include(AccountBlock::Account.where(school_id: @school.id).joins(:role).where(roles: { name: "Teacher" }).count.to_s)
      end
    end
  end
end