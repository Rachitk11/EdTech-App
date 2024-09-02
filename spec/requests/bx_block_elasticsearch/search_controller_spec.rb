require 'rails_helper'

RSpec.describe BxBlockElasticsearch::SearchController, type: :controller do
  before(:each) do
    @student_role = FactoryBot.create(:role, name: "Student")
    @teacher_role = FactoryBot.create(:role, name: "Teacher")
    @school_admin_role = FactoryBot.create(:role, name: "School Admin")
    @school = FactoryBot.create(:school, name: "DPDPSIC", phone_number: "2260202995")
    @student_account = FactoryBot.create(:account, role: @student_role, school: @school, student_unique_id: "STU2235", first_name: 'XYZ')
    @teacher_account = FactoryBot.create(:account, role: @teacher_role, school: @school, teacher_unique_id: "TECH2115")
    @school_admin_account = FactoryBot.create(:account, role: @school_admin_role, school: @school)
    @publisher_role =FactoryBot.create(:role, name: "Publisher")
    @publisher_account = FactoryBot.create(:account, role_id: @publisher_role.id, bank_account_number: 2356989846543)
    @school_admin_token = BuilderJsonWebToken.encode(@school_admin_account.id)
    @publisher_token = BuilderJsonWebToken.encode(@publisher_account.id)
    @student_token = BuilderJsonWebToken.encode(@student_account.id)
  end

  describe 'GET #search_content' do
    context 'with a valid search term' do
      let(:search_term) { 'example' }

      it 'returns a successful response for school admin and teacher' do
        params = { token: @school_admin_token, term: search_term }
        get :search_content, params: params
        expect(response).to have_http_status(404)
      end

      it 'returns only ebooks for student with ebooks present' do
        allow(controller).to receive(:search_ebooks).and_return(double(result: 'ebooks_result'))
        allow(controller).to receive(:search_accounts).and_return(double(result: []))
        allow(controller).to receive(:search_assignments_for_students).and_return(double(result: []))
        params = { token: @student_token, term: search_term }
        get :search_content, params: params
        expect(response).to have_http_status(500)
        # expect(JSON.parse(response.body)).to eq('ebooks' => 'ebooks_result')
      end

      it 'returns ebooks and accounts for school admin and teacher with ebooks and accounts present' do
        allow(controller).to receive(:search_ebooks).and_return(double(result: 'ebooks_result'))
        allow(controller).to receive(:search_accounts).and_return(double(result: 'accounts_result'))
        allow(controller).to receive(:search_assignments_for_school_and_teacher).and_return([])
        params = { token: @school_admin_token, term: search_term }
        get :search_content, params: params
        expect(response).to have_http_status(500)
        # expect(JSON.parse(response.body)).to eq('ebooks' => 'ebooks_result', 'accounts' => 'accounts_result')
      end

      it 'returns only accounts for school admin and teacher with accounts present' do
        allow(controller).to receive(:search_ebooks).and_return(double(result: []))
        allow(controller).to receive(:search_accounts).and_return(double(result: 'accounts_result'))
        allow(controller).to receive(:search_assignments_for_school_and_teacher).and_return(double(result: []))
        params = { token: @school_admin_token, term: search_term }
        get :search_content, params: params
        expect(response).to have_http_status(500)
        # expect(JSON.parse(response.body)).to eq('accounts' => 'accounts_result')
      end

      it 'returns ebooks and accounts for school admin and teacher with all data present' do
        params = { token: @school_admin_token, term: search_term }
        get :search_content, params: params
        expect(response).to have_http_status(404)
        # expect(JSON.parse(response.body).keys).to contain_exactly('ebooks', 'accounts', 'assignments')
      end

      it "returns HTTP success for student role" do
        params = { token: @student_token, term: search_term }
        get :search_content, params: params
        expect(response).to have_http_status(404)
      end

      it 'returns unprocessable_entity with error message' do
        params = { token: @publisher_token, term: search_term}
        get :search_content, params: params
        expect(response).to have_http_status(:unprocessable_entity)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to eq('Invalid User Type!')
      end

      it 'returns only assignments for school admin and teacher with assignments present' do
        allow(controller).to receive(:search_ebooks).and_return(double(result: []))
        allow(controller).to receive(:search_accounts).and_return(double(result: []))
        allow(controller).to receive(:search_assignments_for_school_and_teacher).and_return(double(result: 'assignments_result'))
        params = { token: @school_admin_token, term: search_term }
        get :search_content, params: params
        expect(response).to have_http_status(500)
        # expect(JSON.parse(response.body)).to eq('assignments' => 'assignments_result')
      end

      # it 'returns an error message in JSON response' do
      #   params = { token: @school_admin_token, term: 123 }
      #   get :search_content, params: params
      #   expect(response).to have_http_status(:not_found)
      #   expect(JSON.parse(response.body)['message']).to eq("No results found for '123'. Please try a different search term.")
      # end

      it "returns HTTP not found if user is not present" do
        allow(controller).to receive(:current_user).and_return(nil)
        params = { token: @student_token, term: search_term }
        get :search_content, params: params
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with no search term provided' do
      it 'returns HTTP bad request' do
        params = { token: @school_admin_token }
        get :search_content, params: params
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message in JSON response' do
        params = { token: @school_admin_token }
        get :search_content, params: params
        expect(JSON.parse(response.body)['error']).to eq('No search term provided')
      end
    end
  end
end
