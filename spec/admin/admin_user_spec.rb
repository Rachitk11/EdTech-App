require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers
RSpec.describe Admin::AdminUsersController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views

  before do
    @admin = AdminUser.find_or_create_by(email: "superadmin201@example.com")
		@admin.role = "super_admin"
		@admin.password = "password"
		@admin.save
		sign_in @admin
  end
   
  describe "#index" do
    it "should render index" do
      get :index
      expect(response).to render_template(:index)
    end 
  end 
    describe "GET #show" do
      it "returns a successful response" do
        get :show, params: { id: @admin.id }
        expect(response).to be_successful
      end
    end

  describe "#create" do
    it "should render create" do
      school = FactoryBot.create(:school, phone_number: 1234512309)
      
      post :new, params: {email: "subaa121dmin@example.com", school_id: school.id, role: "sub_admin", password: "123123", password_confirmation: "123123"}

      expect(response).to have_http_status(200)
    end 
  end 
end 