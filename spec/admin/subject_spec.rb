require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers
RSpec.describe Admin::SubjectsController, type: :controller do
	include Devise::Test::ControllerHelpers
	render_views
	before(:each) do
		@admin = AdminUser.find_or_create_by(email: "superadmin@example.com")
		@admin.role = "super_admin"
		@admin.password = "password"
		@admin.save
		sign_in @admin
		@subject = BxBlockCatalogue::Subject.create(subject_name: FFaker::Name.first_name)
	end

	describe "get#index" do
		it "listing of subject" do
			get :index
			expect(response).to have_http_status(200)
		end
	end

	describe "delete#destroy" do
		it "destroy record" do
			delete :destroy, params:{id: @subject.id}
			expect(response).to have_http_status(302)
		end
	end

	describe "get#show" do
		it "show the subject" do
			get :show, params: {id: @subject.id}
			expect(response).to have_http_status(200)
		end
	end

	describe "get#create" do
		it "create new record" do
			post :new, params: { subject_name: "Science" }
			expect(response).to have_http_status(200)
		end
	end
end