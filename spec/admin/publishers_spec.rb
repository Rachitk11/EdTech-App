require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers
RSpec.describe Admin::PublishersController, type: :controller do
	include Devise::Test::ControllerHelpers
	render_views
	before(:each) do
		@admin = AdminUser.find_or_create_by(email: "superadmin@example.com")
		@admin.role = "super_admin"
		@admin.password = "password"
		@admin.save
		sign_in @admin
		@role = BxBlockRolesPermissions::Role.find_or_create_by(name: "Publisher")
		@publisher = FactoryBot.create(:account, role_id: @role.id, full_phone_number: "7988887466", bank_account_number: "987876765698", ifsc_code: "PUBL29197")
	end

	describe "get#index" do
		it "return publishers" do
			get :index
			expect(response).to have_http_status(200)
		end
	end

	describe "delete#destroy" do
		it "destroy record" do
			delete :destroy, params:{id: @publisher.id}
			expect(response).to have_http_status(302)
		end
	end

	describe "get#show" do
		it "return  specific publisher" do
			get :show, params: {id: @publisher.id}
			expect(response).to have_http_status(200)
		end
	end

	describe "get#create" do
		it "create new record" do
			post :new, params: {first_name: "edutech", last_name: "app", email: "edutech@gmail.com", role_id: @role.id, full_phone_number: "8767656545"}
			expect(response).to have_http_status(200)
		end
	end

	describe 'after_create callback' do
		it 'after_create callback' do
			post :create, params: {first_name: "publisher_edutech12", last_name: "publisher1", email: "publisher123@gmail.com", role_id: @role.id, full_phone_number: "9865658734", publication_house_name: "PUB145", bank_account_number: "201100000365", ifsc_code: "PUBL2014"}
		end
  end
end