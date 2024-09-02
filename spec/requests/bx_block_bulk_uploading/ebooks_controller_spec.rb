require 'rails_helper'

RSpec.describe BxBlockBulkUploading::EbooksController, type: :controller do
  before(:each) do
    @school_admin_role = FactoryBot.create(:role, name: "School Admin")
    @school = FactoryBot.create(:school, name: "DBPSIC", phone_number: "8762256995")
    @publisher_role =FactoryBot.create(:role, name: "Publisher")
    @school_admin_account = FactoryBot.create(:account, role_id: @school_admin_role.id, school_id: @school.id )
    @publisher_account = FactoryBot.create(:account, role_id: @publisher_role.id, bank_account_number: 2374289822243)
    @school_admin_token = BuilderJsonWebToken.encode(@school_admin_account.id)
    @publisher_token = BuilderJsonWebToken.encode(@publisher_account.id)
  end
  describe 'GET #get_ebooks' do
    it 'returns a successful response' do
      params = { token: @school_admin_token}
      get :get_ebooks, params: params
      expect(response).to have_http_status(:ok)
    end

    it 'returns a list of ebooks' do
      create_list(:ebook, 8)

      params = { token: @school_admin_token}
      get :get_ebooks, params: params

      expect(response).to have_http_status(:ok)
    end

    it 'returns a message when there are no ebooks' do
      params = { token: @school_admin_token}
      get :get_ebooks, params: params

      expect(response).to have_http_status(:ok)
    end
  end

   describe 'GET #show' do
    let(:ebook) { create(:ebook) }

    context 'when user is present' do

      it 'returns a successful response' do
        params = { token: @school_admin_token, id: ebook.id}
        get :show, params: params
        expect(response).to have_http_status(:ok)
      end

      it 'returns a not found message if ebook not found' do
        params = { token: @school_admin_token, id: 999}
        get :show, params: params

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
