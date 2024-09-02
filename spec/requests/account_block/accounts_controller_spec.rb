require 'rails_helper'
RSpec.describe 'AccountBlock::Accounts', type: :request do
  role = BxBlockRolesPermissions::Role.find_or_create_by(name: "Student")
  school = BxBlockCategories::School.create(email: "support1@test.com", board: "UP Board", principal_name: "PP Singh", name: "AN International School123", phone_number: "8785556565")
  account = FactoryBot.create(:account, school_id: school.id, role_id: role.id)
  unique_id_path = '/account_block/accounts/validate_unique_id'
  user_data_path = '/account_block/accounts/user_data'
  deactivate_path = '/account_block/accounts/deactivate'
  SCHOOL_ADMIN = "School Admin"
  STUDENT = "Student"
  TEACHER = "Teacher"
  PUBLISHER = "Publisher"


  describe "GET#validate_unique_id" do
    let(:invalid_user_type) do
      {
        "data": {
          "type": "invalid",
          "unique_id": account.teacher_unique_id
        }
      }
    end

    let(:request_params_teacher) do
      {
        "data": {
          "type": TEACHER,
          "unique_id": account.teacher_unique_id
        }
      }
    end

    let(:request_params_teacher_72) do
      {
        "data": {
          "type": TEACHER,
          "unique_id": "wrong_id"
        }
      }
    end

    it 'return data' do
      post unique_id_path, params: invalid_user_type
      expect(response).to have_http_status(422)
    end

    it 'return data' do
      post unique_id_path, params: request_params_teacher
      expect(response).to have_http_status(:ok)
    end

    it 'return error' do
      post unique_id_path, params: request_params_teacher_72
      json_data = JSON.parse(response.body)
      expect(json_data["errors"]).to eql("Please provide valid details")
    end


  	let(:request_params) do
  		{
  			"data": {
          "type": STUDENT,
  				"unique_id": account.student_unique_id
  			}
  		}
  	end

  	let(:request_params_72) do
  		{
  			"data": {
          "type": STUDENT,
  				"unique_id": "wrong_id",
          "pin": "1234"
  			}
  		}
  	end

  	it 'return specific account data' do
  		post unique_id_path, params: request_params
  		expect(response).to have_http_status(:ok)
  	end

  	it 'return error' do
  		post unique_id_path, params: request_params_72
  		json_data = JSON.parse(response.body)
  		expect(json_data["errors"]).to eql("Please provide valid details")
  	end

    let(:request_params_school_admin) do
      {
        "data": {
          "type": SCHOOL_ADMIN,
          "email": account.email
        }
      }
    end

    it 'return user data' do
      post unique_id_path, params: request_params_school_admin
      expect(response).to have_http_status(:ok)
    end

    let(:request_params_publisher) do
      {
        "data": {
          "type": PUBLISHER,
          "email": account.email
        }
      }
    end

    it 'return user data' do
      post unique_id_path, params: request_params_publisher
      expect(response).to have_http_status(:ok)
    end
  end

  describe "put#update" do
    let(:request_params) do
      {
        "data": {
          "guardian_name": "8989",
        }
      }
    end

    it "return user's data" do
      put "/account_block/accounts/#{account.id}", params: request_params
      expect(response).to have_http_status(:ok)
    end

  end

  describe "get#show" do
    it 'return account data' do
      get "/account_block/accounts/#{account.id}"
      expect(response).to have_http_status(:ok)
    end

  end


  describe "POST #create" do
  	let(:request_params) do
  		{
  			id: account.id,
  			"data": {
  				"pin": 8989,
  				"confirm_pin": 8989,
  			}
  		}
  	end

    let(:request_params_wrong) do
      {
        id: account.id,
        "data": {
          "pin": 8989,
          "confirm_pin": 8889,
        }
      }
    end

    it 'set pin' do
      post '/account_block/accounts' , params: request_params
      json_data = JSON.parse(response.body)
      expect(response).to have_http_status(200)
    end

  	it 'wrong pin' do
			post '/account_block/accounts' , params: request_params_wrong
			json_data = JSON.parse(response.body)
      expect(json_data["message"]).to eql("confirm pin is wrong")
		end
  end

  describe "users data" do
    context "student user type" do
      let(:request_params) do
        {
          type: STUDENT,
          "data": {
            "unique_id": "123",
            "school_id": 12,
            "email": "g@gmail.com"
          }
        }
      end

      let(:request_params_school_missmatch) do
        {
          type: STUDENT,
          "data": {
            "unique_id": account.student_unique_id,
            "school_id": 0,
            "email": account.guardian_email
          }
        }
      end

      let(:request_params_guardian_email_wrong) do
        {
          type: STUDENT,
          "data": {
            "unique_id": account.student_unique_id,
            "school_id": school.id,
            "email": "wrong001@gmail.com"
          }
        }
      end

      let(:request_params_valid) do
        {
          type: STUDENT,
          "data": {
            "unique_id": account.student_unique_id,
            "school_id": school.id,
            "email": account.guardian_email
          }
        }
      end

      it "return student" do
        post user_data_path, params: request_params_valid
        json_data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
      end

      it "return school name invalid error" do
        post user_data_path, params: request_params_school_missmatch
        json_data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
      end

      it "return guardian email wrong error" do
        post user_data_path, params: request_params_guardian_email_wrong
        json_data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
      end

      it "return student not found error" do
        post user_data_path, params: request_params
        json_data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
      end
    end

    context "teacher type user" do
      role = BxBlockRolesPermissions::Role.find_or_create_by(name: "Teacher")
      school = FactoryBot.create(:school, phone_number: "8787676565")
      account = FactoryBot.create(:account, school_id: school.id, role_id: role.id, full_phone_number: "8787654323")

      let(:request_params) do
        {
          type: TEACHER,
          "data": {
            "unique_id": "000",
            "school_id": 12,
            "contact_number": "9876765654"
          }
        }
      end

      let(:request_params_school_missmatch) do
        {
          type: TEACHER,
          "data": {
            "unique_id": account.teacher_unique_id,
            "school_id": 0,
            "contact_number": account.full_phone_number
          }
        }
      end

      let(:request_params_contact_number_wrong) do
        {
          type: TEACHER,
          "data": {
            "unique_id": account.teacher_unique_id,
            "school_id": school.id,
            "contact_number": "0000000000"
          }
        }
      end

      let(:request_params_valid) do
        {
          type: TEACHER,
          "data": {
            "unique_id": account.teacher_unique_id,
            "school_id": school.id,
            "contact_number": account.full_phone_number
          }
        }
      end

      it "return teacher" do
        post user_data_path, params: request_params_valid
        json_data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
      end

      it "return school name invalid error" do
        post user_data_path, params: request_params_school_missmatch
        json_data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
      end

      it "return contact number wrong error" do
        post user_data_path, params: request_params_contact_number_wrong
        json_data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
      end

      it "return teacher not found error" do
        post user_data_path, params: request_params
        json_data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
      end
    end

    context "school admin type" do
      role = BxBlockRolesPermissions::Role.find_or_create_by(name: SCHOOL_ADMIN)
      school = FactoryBot.create(:school, phone_number: "8787676565")
      account = FactoryBot.create(:account, school_id: school.id, role_id: role.id, full_phone_number: "8787654323")

      let(:request_params) do
        {
          type: SCHOOL_ADMIN,
          "data": {
            "email": "wrong007@gmail.com",
            "school_id": 12,
            "contact_number": "9876765654"
          }
        }
      end

      let(:request_params_school_missmatch) do
        {
          type: SCHOOL_ADMIN,
          "data": {
            "email": account.email,
            "school_id": 0,
            "contact_number": account.full_phone_number
          }
        }
      end

      let(:request_params_contact_number_wrong) do
        {
          type: SCHOOL_ADMIN,
          "data": {
            "email": account.email,
            "school_id": school.id,
            "contact_number": "0000000000"
          }
        }
      end

      let(:request_params_valid) do
        {
          type: SCHOOL_ADMIN,
          "data": {
            "email": account.email,
            "school_id": school.id,
            "contact_number": account.full_phone_number
          }
        }
      end

      it "return school admin data" do
        post user_data_path, params: request_params_valid
        json_data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
      end

      it "return school name invalid error for admin" do
        post user_data_path, params: request_params_school_missmatch
        json_data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
      end

      it "return contact number wrong error for admin" do
        post user_data_path, params: request_params_contact_number_wrong
        json_data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
      end

      it "return school admin not found error" do
        post user_data_path, params: request_params
        json_data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
      end
    end

    context "publisher type user" do
      role = BxBlockRolesPermissions::Role.find_or_create_by(name: "Publisher")
      school = FactoryBot.create(:school, phone_number: "8787676565")
      account = FactoryBot.create(:account, school_id: school.id, role_id: role.id, full_phone_number: "8787654323", publication_house_name: 'xyz')

      let(:request_params) do
        {
          type: PUBLISHER,
          "data": {
            "email": "wrong@gmail.com",
            "publication_name": "12",
            "contact_number": "9876765654"
          }
        }
      end

      let(:request_params_publication_house_name_mismatch) do
        {
          type: PUBLISHER,
          "data": {
            "email": account.email,
            "publication_name": "0",
            "contact_number": account.full_phone_number
          }
        }
      end

      let(:request_params_contact_number_wrong) do
        {
          type: PUBLISHER,
          "data": {
            "email": account.email,
            "publication_name": account.publication_house_name,
            "contact_number": "0000000000"
          }
        }
      end

      let(:request_params_valid) do
        {
          type: PUBLISHER,
          "data": {
            "email": account.email,
            "publication_name": account.publication_house_name,
            "contact_number": account.full_phone_number
          }
        }
      end

      it "return Publisher" do
        post user_data_path, params: request_params_valid
        json_data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
      end
      

      it "return school name invalid error for Publisher" do
        post user_data_path, params: request_params_publication_house_name_mismatch
        json_data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
      end

      it "return contact number wrong error for Publisher" do
        post user_data_path, params: request_params_contact_number_wrong
        json_data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
      end

      it "return Publisher not found error" do
        post user_data_path, params: request_params
        json_data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
      end
    end

    context "invalid user typr" do
      let(:request_params) do
        {
          type: "wrong",
          "data": {
            "email": account.email,
            "publication_name": account.publication_house_name,
            "contact_number": "0000000000"
          }
        }
      end
      it "return Publisher not found error" do
        post user_data_path, params: request_params
        json_data = JSON.parse(response.body)
        expect(response).to have_http_status(422)
      end
    end
  end

  it "deactivates the account" do
    account.update(activated: true)
    @token = BuilderJsonWebToken.encode(account.id)
    patch deactivate_path, params: { token: @token }
    expect(response).to have_http_status(200)
  end

  it "returns an error if the account is already deactivated" do
    @token = BuilderJsonWebToken.encode(account.id)
    patch deactivate_path, params: { token: @token }
    expect(response).to have_http_status(422)
  end


 


end
