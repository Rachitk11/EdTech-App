require 'rails_helper'
require 'spec_helper'

RSpec.describe BxBlockProfile::ProfilesController, type: :controller do
  before(:each) do
    @student_role = FactoryBot.create(:role, name: "Student")
    @teacher_role = FactoryBot.create(:role, name: "Teacher")
    @school_admin_role = FactoryBot.create(:role, name: "School Admin")
    @publisher_role =FactoryBot.create(:role, name: "Publisher")
    @student_account = FactoryBot.create(:account, role_id: @student_role.id , student_unique_id: "ST9635")
    @teacher_account = FactoryBot.create(:account, role_id: @teacher_role.id, teacher_unique_id: "TECH00055")
    @school_admin_account = FactoryBot.create(:account, role_id: @school_admin_role.id)
    @publisher_account = FactoryBot.create(:account, role_id: @publisher_role.id, bank_account_number: 2374289846543)
    @student_profile = FactoryBot.create(:profile, account_id: @student_account.id)
    @teacher_profile = FactoryBot.create(:profile, account_id: @teacher_account.id)
    @school_admin_profile = FactoryBot.create(:profile, account_id: @school_admin_account.id)
    @publisher_profile = FactoryBot.create(:profile, account_id: @publisher_account.id)
    # @student_profile.save
    # @teacher_profile.save
    # @school_admin_profile.save
    # @publisher_profile.save
    # @token = authenticated_header(request, @account)
    @student_token = BuilderJsonWebToken.encode(@student_account.id)
    @teacher_token = BuilderJsonWebToken.encode(@teacher_account.id)
    @school_admin_token = BuilderJsonWebToken.encode(@school_admin_account.id)
    @publisher_token = BuilderJsonWebToken.encode(@publisher_account.id)
  end

  describe 'bx_block_profile/profiles#update' do
    it 'when student update the profile with the updated values' do
      params = { token: @student_token, profile: {guardian_email: "testing2@gmail.com"} }
      put :update, params: params
      data = JSON.parse(response.body)
      expect(response).to have_http_status :ok
    end

    it 'when teacherupdate the profile with the updated values' do
      params = {token: @teacher_token, profile: {email: "testing1@gmail.com"}}
      put :update, params: params
      data = JSON.parse(response.body)
      expect(response).to have_http_status :ok
    end

    it 'when school admin update the profile with the updated values' do
      params = {token: @school_admin_token, profile: {email: "testing2@gmail.com"}}
      put :update, params: params
      data = JSON.parse(response.body)
      expect(response).to have_http_status :ok
    end

    it 'when publisher update the profile with the updated values' do
      params = {token: @publisher_token, profile: {email: "testing3@gmail.com"}}
      put :update, params: params
      data = JSON.parse(response.body)
      expect(response).to have_http_status :ok
    end

    it 'when user do not  update the profile with the updated values' do
      @student_profile.destroy
      @teacher_profile.destroy
      @school_admin_profile.destroy
      @publisher_profile.destroy
      params = {token: @student_token,  profile: {email: "testing@gmail.com"}}
      put :update, params: params
      data = JSON.parse(response.body)
      expect(response).to have_http_status :unprocessable_entity
    end

    # it 'Invaild use role' do
    #   role =FactoryBot.create(:role, name: "Role")
    #   account = FactoryBot.create(:account, role_id: role.id)
    #   profile = FactoryBot.create(:profile, account_id: account.id)
    #   token = BuilderJsonWebToken.encode(account.id)
    #   params = {token: token, profile: {email: nil}}
    #   put :update, params: params
    #   data = JSON.parse(response.body)
    #   expect(response).to have_http_status :unprocessable_entity
    # end
  end

  describe 'bx_block_profile/profile#show' do
    it 'when student show their profile' do
      get :show, params: { token: @student_token}
      job = JSON.parse(response.body)
      expect(response).to have_http_status :ok
    end

    it 'when teacher show their profile' do
      params = {token: @teacher_token}
      get :show, params: params
      data = JSON.parse(response.body)
      expect(response).to have_http_status :ok
    end

    it 'when school admin show their profile' do
      params = {token: @school_admin_token}
      get :show, params: params
      data = JSON.parse(response.body)
      expect(response).to have_http_status :ok
    end

    it 'when publisher show their profile' do
      params = {token: @publisher_token}
      get :show, params: params
      data = JSON.parse(response.body)
      expect(response).to have_http_status :ok
    end

    it 'when user not show their profile' do
      @student_profile.destroy
      @teacher_profile.destroy
      @school_admin_profile.destroy
      @publisher_profile.destroy
      params = {token: @student_token}
      get :show, params: params
      data = JSON.parse(response.body)
      expect(response).to have_http_status :unprocessable_entity
    end
  end
  describe 'GET #show_about_us' do
    it 'returns success with valid data' do
      BxBlockTermsAndConditions::TermsAndCondition.delete_all
      BxBlockContentManagement::AboutUs.delete_all
      term = create(:terms_and_conditions)
      about_us = create(:about_us)

      get :show_about_us

      expect(response).to have_http_status(:ok)
    end

    context 'when data is missing' do
      it 'returns not found' do
        BxBlockTermsAndConditions::TermsAndCondition.delete_all
        BxBlockContentManagement::AboutUs.delete_all
        get :show_about_us

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq('message' => 'Data not found')
      end
    end
  end

  describe 'GET #show_faq' do
    it 'returns success with valid data' do
      faq1 = create(:faq_question)
      faq2 = create(:faq_question)

      get :show_faq

      expect(response).to have_http_status(:ok)
    end

    it 'returns not found with missing data' do
      BxBlockContentManagement::FaqQuestion.delete_all
      get :show_faq

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to eq('message' => 'Data not found')
    end
  end
end