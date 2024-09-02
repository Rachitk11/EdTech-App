require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers
RSpec.describe Admin::AboutUsController, type: :controller do
	include Devise::Test::ControllerHelpers
	render_views
	
	before(:each) do
		@admin = AdminUser.find_or_create_by(email: "superadmin@example.com")
		@admin.role = "super_admin"
		@admin.password = "password"
		@admin.save
		sign_in @admin
		@terms = BxBlockContentManagement::AboutUs.create(email: "support4@example.com", phone_number: 8172655478, title: "Title4", description: "This is description4")
	end

	describe "get#index" do
		it "return terms" do
			get :index
			expect(response).to have_http_status(200)
		end
	end

	describe "get#create" do
		it "create new term" do
			post :new, params: {email: "support5@example.com", phone_number: 8552635478, title: "Title5", description: "This is description5"}
			expect(response).to have_http_status(200)
		end
	end

	describe "get#show" do
		it "return  specific term" do
			BxBlockContentManagement::AboutUs.delete_all
			terms = FactoryBot.create(:about_us, id: 1, email: "support6@example.com", phone_number: 8172665478, title: "Title6", description: "This is description6")
      get :show, params: {id: terms.id}
			expect(response).to have_http_status(200)
		end
	end
end