require 'rails_helper'
RSpec.describe 'BxBlockContactUs::Contact', type: :request do
	before(:each) do
		@role = BxBlockRolesPermissions::Role.find_or_create_by(name: "Student")
		@school = FactoryBot.create(:school, name: "SVMIC School", phone_number: "8787676565", email: "school@gmail.com")
		@account = FactoryBot.create(:account, role_id: @role.id, full_phone_number: "8787654323", student_unique_id: "unique_123")
	end
	PATH_URL = '/bx_block_contact_us/contacts'
	FORGOT_PASSWORD = "Forgot Password"
	SCHOOL_ADMIN = "School Admin"
	STUDENT = "Student"
	TEACHER = "Teacher"
	PUBLISHER = "Publisher"
	PROVIDE_EMAIL = "please provide email id"
	describe "POST #create" do
		context "when user type is wrong" do
			let(:request_params) do
				{
					"data": {
						type: "wrong",
						"email": @account.email,
		  			"st_id": @account.student_unique_id,
		  			"issue": FORGOT_PASSWORD
					}
				}
			end
			it 'return error' do
	  			post PATH_URL , params: request_params
	  			json_data = JSON.parse(response.body)
	        	expect(response).to have_http_status(:unprocessable_entity)
	  		end
		end

	  	context "when user raising Forgot Password issue" do
		  	let(:request_params_25) do
	  			{
		  			"data": {
		  				"type": STUDENT,
		  				"email": @account.email,
		  				"issue": FORGOT_PASSWORD

		  			}
		  		}
		  	end

		  	let(:request_params_52) do
	  			{
		  			"data": {
		  				"type": STUDENT,
		  				"st_id": @account.student_unique_id,
		  				"issue": FORGOT_PASSWORD
		  			}
		  		}
		  	end

			  let(:request_params_101) do
				{
					"data": {
						"type": TEACHER,
						"unique_id": @account.student_unique_id,
						"issue": FORGOT_PASSWORD,
						"email": @account.email
					}
				}
			end
				
	  		it 'return guardian email error' do
	  			post PATH_URL , params: request_params_52
	  			json_data = JSON.parse(response.body)
	        expect(json_data["errors"]).to eql(PROVIDE_EMAIL)
	  		end

	  		it 'return student id error' do
	  			post PATH_URL , params: request_params_25
	  			json_data = JSON.parse(response.body)
	        expect(json_data["errors"]).to eql("please provide Student id")
	  		end

			  it 'return Invalid unique id error' do
				@account.update(activated: true)
				post PATH_URL , params: request_params_101
				json_data = JSON.parse(response.body)
		  expect(json_data["errors"]).to eql("please provide valid teacher id")
			end
	  	end

	  	context "when user raising another issue" do
		  	let(:request_params_12) do
	  			{
		  			"data": {
		  				"type": STUDENT,
		  				"issue": "Student Id not Found"
		  			}
		  		}
		  	end

		  	it 'return please provide guardian email id' do
	  			post PATH_URL , params: request_params_12
	  			json_data = JSON.parse(response.body)
	        expect(json_data["errors"]).to eql(PROVIDE_EMAIL)
	  		end
			  it 'create contacting  for student ' do
				@account.update(activated: true)
				post PATH_URL , params: request_params_12
				json_data = JSON.parse(response.body)
			  expect(response).to have_http_status(200)
			end
	  	end

	  	context "Forgot Password issue" do
	  		let(:request_params) do
	  			{
		  			"data": {
		  				"type": TEACHER,
		  				"email": @account.email,
		  				"st_id": @account.teacher_unique_id,
		  				"issue": FORGOT_PASSWORD
		  			}
		  		}
		  	end

		  	let(:request_params_35) do
	  			{
		  			"data": {
		  				"type": TEACHER,
		  				"email": @account.email,
		  				"issue": FORGOT_PASSWORD
		  			}
		  		}
		  	end

		  	let(:request_params_53) do
	  			{
		  			"data": {
		  				"type": TEACHER,
		  				"st_id": @account.teacher_unique_id,
		  				"issue": FORGOT_PASSWORD
		  			}
		  		}
		  	end


			  let(:request_params_102) do
				{
					"data": {
						"type": PUBLISHER,
						"unique_id": @account.student_unique_id,
						"issue": FORGOT_PASSWORD,
						"email": @account.email
					}
				}
			end
			it 'return Invalid unique id error' do
				@account.update(activated: true)
				post PATH_URL , params: request_params_102
				json_data = JSON.parse(response.body)
		  expect(json_data["errors"]).to eql(nil)
			end
		  	it 'return error please provide teacher id' do
				@account.update(activated:true)

	  			post PATH_URL , params: request_params_35
	  			json_data = JSON.parse(response.body)
	        expect(json_data["errors"]).to eql("please provide Teacher id")
	  		end
	  		it 'return error please provide teacher email id' do
	  			post PATH_URL , params: request_params_53
	  			json_data = JSON.parse(response.body)
	        expect(json_data["errors"]).to eql(PROVIDE_EMAIL)
	  		end
		  	it 'create successfully' do
	  			post PATH_URL , params: request_params
	  			json_data = JSON.parse(response.body)
	        	expect(response).to have_http_status(200)
	  		end

			  it 'create cont for teacher' do
				@account.update(activated: true)
				post PATH_URL , params: request_params
				json_data = JSON.parse(response.body)
			  expect(response).to have_http_status(200)
			end
	  	end

	  	context "user have other issue" do
	  		let(:request_params) do
	  			{
		  			"data": {
		  				"type": TEACHER,
		  				"email": @account.email,
		  				"issue": "Teacher Id not Found"
		  			}
		  		}
		  	end
		  	let(:request_params_98) do
	  			{
		  			"data": {
		  				"type": TEACHER,
		  				"issue": "Teacher Id not Found"
		  			}
		  		}
		  	end
		  	it 'return error please provide teacher email id' do
				@account.update(activated: true)
	  			post PATH_URL , params: request_params_98
	  			json_data = JSON.parse(response.body)
	        expect(json_data["errors"]).to eql(PROVIDE_EMAIL)
	  		end
		  	it 'return status code 201' do
	  			post PATH_URL , params: request_params
	  			json_data = JSON.parse(response.body)
	        expect(response).to have_http_status(200)
	  		end
	  	end

	  	context "when user Forgot Password" do
	  		let(:request_params) do
	  			{
		  			"data": {
		  				"type": SCHOOL_ADMIN,
		  				"email": @account.email,
		  				"school_email": @school.email,
		  				"issue": FORGOT_PASSWORD
		  			}
		  		}
		  	end
		  	it 'create contactus request successfully' do
	  			post PATH_URL , params: request_params
	  			json_data = JSON.parse(response.body)
	        	expect(response).to have_http_status(200)
	  		end

	  		let(:request_params_80) do
	  			{
		  			"data": {
		  				"type": SCHOOL_ADMIN,
		  				"school_email": @school.email,
		  				"issue": FORGOT_PASSWORD
		  			}
		  		}
		  	end
		  	it 'raise error message please provide school admin email id' do
	  			post PATH_URL , params: request_params_80
	  			json_data = JSON.parse(response.body)
	        expect(json_data["errors"]).to eql(PROVIDE_EMAIL)
	  		end

	  		let(:request_params_08) do
	  			{
		  			"data": {
		  				"type": SCHOOL_ADMIN,
		  				"email": @account.email,
		  				"issue": FORGOT_PASSWORD
		  			}
		  		}
		  	end
		  	it 'return message please provide school email id' do
	  			post PATH_URL , params: request_params_08
	  			json_data = JSON.parse(response.body)
	        expect(json_data["errors"]).to eql(nil)
	  		end
			  it 'create for admin' do
				@account.update(activated: true)
				post PATH_URL , params: request_params_08
				json_data = JSON.parse(response.body)
			  expect(response).to have_http_status(201)
			end
	  	end

	  	context "other issues" do
	  		let(:request_params_80) do
	  			{
		  			"data": {
		  				"type": SCHOOL_ADMIN,
		  				"school_email": @school.email,
		  				"issue": "othen than forgot password"
		  			}
		  		}
		  	end
		  	it 'return error message please provide school admin email id' do
	  			post PATH_URL , params: request_params_80
	  			json_data = JSON.parse(response.body)
	        expect(json_data["errors"]).to eql(PROVIDE_EMAIL)
	  		end

	  		let(:request_params) do
	  			{
		  			"data": {
		  				"type": SCHOOL_ADMIN,
		  				"email": @account.email,
		  				"issue": "other issues"
		  			}
		  		}
		  	end
		  	it ' has raised query to resolve issue' do
	  			post PATH_URL , params: request_params
	  			json_data = JSON.parse(response.body)
	        expect(response).to have_http_status(200)
	  		end
	  	end

	  	context "when issue is Forgot Password" do
	  		let(:request_params_80) do
	  			{
		  			"data": {
		  				"type": PUBLISHER,
		  				"issue": FORGOT_PASSWORD
		  			}
		  		}
		  	end
		  	it 'return message please provide Publisher email id' do
	  			post PATH_URL , params: request_params_80
	  			json_data = JSON.parse(response.body)
	        expect(json_data["errors"]).to eql(PROVIDE_EMAIL)
	  		end
	  		let(:request_params) do
	  			{
		  			"data": {
		  				"type": PUBLISHER,
		  				"email": @account.email,
		  				"issue": FORGOT_PASSWORD
		  			}
		  		}
		  	end
		  	it 'has created contact us' do
	  			post PATH_URL , params: request_params
	  			json_data = JSON.parse(response.body)
	        	expect(response).to have_http_status(200)
	  		end
			  it 'create contacts ' do
				@account.update(activated: true)
				post PATH_URL , params: request_params
				json_data = JSON.parse(response.body)
			  expect(response).to have_http_status(201)
			end
	  	end

	  	context "when issue is not Forgot Password" do
	  		let(:request_params_80) do
	  			{
		  			"data": {
		  				"type": PUBLISHER,
		  				"phone_number": @account.full_phone_number,
		  				"name": "publisher",
		  				"issue": "employee id issue"
		  			}
		  		}
		  	end
		  	it 'return error please provide publisher email id' do
	  			post PATH_URL , params: request_params_80
	  			json_data = JSON.parse(response.body)
	        expect(json_data["errors"]).to eql(PROVIDE_EMAIL)
	  		end

	  		let(:request_params_98) do
	  			{
		  			"data": {
		  				"type": PUBLISHER,
		  				"email": @account.email,
		  				"phone_number": @account.full_phone_number,
		  				"issue": "isue is not forgot password"
		  			}
		  		}
		  	end
		  	it 'return error please provide publisher name' do
	  			post PATH_URL , params: request_params_98
	  			json_data = JSON.parse(response.body)
	        expect(json_data["errors"]).to eql("please provide Publisher name")
	  		end


	  		let(:request_params) do
	  			{
		  			"data": {
		  				"type": PUBLISHER,
		  				"phone_number": @account.full_phone_number,
		  				"email": @account.email,
		  				"name": "publisher",
		  				"issue": "other issue"
		  			}
		  		}
		  	end
		  	it 'has raised issue' do
	  			post PATH_URL , params: request_params
	  			json_data = JSON.parse(response.body)
	        	expect(response).to have_http_status(201)
	  		end
	  	end
	end
end
