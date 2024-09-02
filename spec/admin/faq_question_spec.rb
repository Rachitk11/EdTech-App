require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers
RSpec.describe Admin::FaqsController, type: :controller do
	include Devise::Test::ControllerHelpers
	render_views
	
	before(:each) do
		@admin = AdminUser.find_or_create_by(email: "superadmin@example.com")
		@admin.role = "super_admin"
		@admin.password = "password"
		@admin.save
		sign_in @admin
		@terms = BxBlockContentManagement::FaqQuestion.create(question: "First Question", answer: "This is answer")
	end

	describe "get#index" do
		it "return terms" do
			get :index
			expect(response).to have_http_status(200)
		end
	end

	describe "get#create" do
		it "create new term" do
			post :new, params: {question: "First Question"}
			expect(response).to have_http_status(200)
		end
	end

	describe "get#show" do
		it "return  specific term" do
			get :show, params: {id: @terms.id}
			expect(response).to have_http_status(200)
		end
	end
end