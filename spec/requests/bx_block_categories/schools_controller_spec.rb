require 'rails_helper'
RSpec.describe 'BxBlockCategories::School', type: :request do
	before(:each) do
		school = BxBlockCategories::School.create(email: "suport@test.com", board: "UP Board", principal_name: "PP Singh", name: "AN International School", phone_number: "8787676565")
	end

	it 'return all schools' do
    get '/bx_block_categories/schools'
    json_data = JSON.parse(response.body)
    expect(response).to have_http_status(:ok)
  end
end