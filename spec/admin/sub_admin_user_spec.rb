require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers
RSpec.describe Admin::SubAdminUsersController, type: :controller do
	include Devise::Test::ControllerHelpers
	render_views
	before(:each) do
    @admin = AdminUser.find_or_create_by(email: "superadmin@example.com")
		@admin.role = "super_admin"
		@admin.password = "password"
		@admin.save
		sign_in @admin
	
    @school_admin_role = FactoryBot.create(:role, name: "School Admin")
    @school = FactoryBot.create(:school, name: "BPSIC", phone_number: "8767656995")
    @school_admin_account = FactoryBot.create(:account, role_id: @school_admin_role.id, school_id: @school.id )
    @subadmin = AdminUser.create(email: @school_admin_account.email, role: "sub_admin", school_id: @school.id, password: "password", password_confirmation: "password")
	
    end

    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
      end  
    end

    describe "#create" do
    it "should render create" do
      # school_admin_role = FactoryBot.create(:role, name: "School Admin")
      school = FactoryBot.create(:school, name: "BPSjkIC", phone_number: "8767656995")
      school_admin_account = FactoryBot.create(:account, role_id: @school_admin_role.id, school_id: school.id )
         
      post :new, params: {email: school_admin_account.email, role: "sub_admin", school_id: school.id, password: "password", password_confirmation: "password"}

      expect(response).to have_http_status(200)
    end 
  end 

    describe "GET #show" do
      it "returns a successful response" do
        # school_admin_role = FactoryBot.create(:role, name: "School Admin")
        school = FactoryBot.create(:school, name: "BPSjkIC", phone_number: "8767656995")
        school_admin_account = FactoryBot.create(:account, role_id: @school_admin_role.id, school_id: school.id )
        admin = AdminUser.find_or_create_by(email: "sub_admin@example.com")
        admin.role = "sub_admin"
        admin.school_id = school.id
        admin.password = "password"
        admin.save
        get :show, params: { id: admin.id }
        expect(response).to be_successful
      end
    end

    
  
end