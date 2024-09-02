require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers
RSpec.describe Admin::TermsAndConditionsController, type: :controller do
	include Devise::Test::ControllerHelpers
	render_views
	
	before(:each) do
		@admin = AdminUser.find_or_create_by(email: "superadmin@example.com")
    @admin.role = "super_admin"
		@admin.password = "password"
		@admin.save
		sign_in @admin
		@terms = BxBlockTermsAndConditions::TermsAndCondition.create(name: "First Term", description: "This is description")
	end

	describe "get#index" do
		it "return terms" do
			get :index
			expect(response).to have_http_status(200)
		end
	end

	describe "get#create" do
		it "create new term" do
			post :new, params: {name: "First Term1"}
			expect(response).to have_http_status(200)
		end
	end

	describe "get#show" do
		it "return  specific term" do
			BxBlockTermsAndConditions::TermsAndCondition.delete_all
			term = BxBlockTermsAndConditions::TermsAndCondition.create(name: "First Term2", description: "This is description2")
			get :show, params: {id: term.id}
			expect(response).to have_http_status(200)
		end
	end
end