require 'rails_helper'
require 'spec_helper'

RSpec.describe BxBlockProfile::PasswordsController, type: :controller do
  before(:each) do
    @student_role = FactoryBot.create(:role, name: "Student")
    @student_account = FactoryBot.create(:account, role_id: @student_role.id, full_phone_number: "6543223434" )
    # @token = authenticated_header(request, @account)
    @student_token = BuilderJsonWebToken.encode(@student_account.id)
  end

  describe 'bx_block_profile/passwords#reset_password' do
    it 'when user reset the password' do
      params = { token: @student_token, data: {pin: "9090", confirm_pin: "9090"} }
      post :reset_password, params: params
      data = JSON.parse(response.body)
      expect(response).to have_http_status :ok
    end

    it 'when token wrong' do
      params = {token: BuilderJsonWebToken.encode(0), data: {pin: "9090", confirm_pin: "9090"}}
      post :reset_password, params: params
      data = JSON.parse(response.body)
      expect(data["errors"][0]).to eql("Record not found")
    end

    it 'when pin wrong' do
      params = {token: @student_token, data: {pin: "9091", confirm_pin: "9090"}}
      post :reset_password, params: params
      data = JSON.parse(response.body)
      expect(response).to have_http_status :ok
    end
  end
end