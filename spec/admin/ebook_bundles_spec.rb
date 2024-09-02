require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers
RSpec.describe Admin::BundleManagementsController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views

  # let!(:ebook1) { create(:ebook, id: 1) }
  # let!(:ebook2) { create(:ebook, id: 2) }

  before(:each) do
    @admin = AdminUser.find_or_create_by(email: "superadmin@example.com")
    @admin.role = "super_admin"
    @admin.password = "password"
    @admin.save
    sign_in @admin
  end

  describe 'GET #index' do
    it 'displays the list of ebooks' do
      @ebook2 = create(:ebook, id: 2)
      bundle2 = create(:bundle_management, title: 'Bundle 2', ebooks: [@ebook2])
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      @ebook3 = create(:ebook, id: 3)
      bundle3 = create(:bundle_management, title: 'Bundle 2', ebooks: [@ebook3])
      get :show, params: { id: bundle3.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end
end