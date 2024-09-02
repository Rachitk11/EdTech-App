require 'rails_helper'

RSpec.describe BxBlockAnalytics7::PublisherAnalyticsController, type: :controller do
  before(:each) do
    @school_admin_role = FactoryBot.create(:role, name: "School Admin")
    @school = FactoryBot.create(:school, name: "BPSIC", phone_number: "8767656995")
    @publisher_role =FactoryBot.create(:role, name: "Publisher")
    @school_admin_account = FactoryBot.create(:account, role_id: @school_admin_role.id, school_id: @school.id )
    @publisher_account = FactoryBot.create(:account, role_id: @publisher_role.id, bank_account_number: 2374289846543)
    @school_admin_token = BuilderJsonWebToken.encode(@school_admin_account.id)
    @publisher_token = BuilderJsonWebToken.encode(@publisher_account.id)
  end

  describe 'GET #publisher_analytics' do

    it 'returns success with user data' do
      params = { token: @publisher_token}
      get :publisher_analytics, params: params
      expect(response).to have_http_status(:ok)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['success']).to be_truthy
      expect(response).to have_http_status(:ok)
    end

    it 'returns unprocessable_entity with error message' do
      params = { token: @school_admin_token}
      get :publisher_analytics, params: params
      expect(response).to have_http_status(:unprocessable_entity)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['message']).to eq('Invalid User!')
    end
  end
end
