require 'rails_helper'

RSpec.describe BxBlockLogin::LoginsController, type: :controller do

  before(:each) do 
    @role = BxBlockRolesPermissions::Role.find_or_create_by(name: "Student")
    @account = FactoryBot.create(:account, role_id: @role.id, full_phone_number: "8787654323", student_unique_id: "ST345", activated: true, pin: "1234", is_reset: false, one_time_pin: "9090")
    @token = BuilderJsonWebToken::JsonWebToken.encode(@account.id)
    request.headers["token"] = BuilderJsonWebToken.encode(@account.id)
  end

  describe "wrong pin" do
    it "return error" do
      post :create, params: {
        "data": {
          "type": @role.name, 
          "attributes": {
            "pin": "2345"
          } 
        } 
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "valid pin" do
    it "return token" do
      post :create, params: {
        "data": {
          "type": @role.name, 
          "attributes": {
            "unique_id": @account.student_unique_id,
            "pin": "1234"
          } 
        } 
      }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "invalid account type" do
    it "will show error" do
      post :create, params: {
        "data": {
          "type": "invalid", 
          "attributes": {
            "pin": "1234"
          } 
        } 
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "is reset false" do
    it "will return error" do
      post :create, params: {
        "data": {
          "type": @role.name, 
          "attributes": {
            "unique_id": @account.student_unique_id,
            "pin": "9090"
          } 
        } 
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "invalid email" do
    it "through error" do
      post :create, params: {
        "data": {
          "type": "Publisher", 
          "attributes": {
            "email": "invalid@gmail.com",
            "pin": "9090"
          } 
        } 
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "valid one time pin" do
    it "raise error" do
      @account.update(is_reset: true)
      post :create, params: {
        "data": {
          "type": @role.name, 
          "attributes": {
            "unique_id": @account.student_unique_id,
            "pin": "9090"
          } 
        } 
      }
      expect(response).to have_http_status(:ok)
    end
  end
end