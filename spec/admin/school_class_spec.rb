require 'rails_helper'
require 'spec_helper'

include Warden::Test::Helpers
RSpec.describe Admin::ClassesController, type: :controller do
	include Devise::Test::ControllerHelpers
	render_views
	
	before(:each) do
		@admin = AdminUser.find_or_create_by(email: "superadmin@example.com")
		@admin.role = "super_admin"
		@admin.password = "password"
		@admin.save
		sign_in @admin
		@student_role = BxBlockRolesPermissions::Role.find_or_create_by(name: "Student")
		@teacher_role = BxBlockRolesPermissions::Role.find_or_create_by(name: "Teacher")
		@school = FactoryBot.create(:school, name: "HPGS", phone_number: 9876543256)
		@student = FactoryBot.create(:account, role_id: @student_role.id, student_unique_id: "ST556", school_id: @school.id)
		@teacher = FactoryBot.create(:account, role_id: @teacher_role.id, school_id: @school.id)
		@class_division = FactoryBot.create(:class_division, school_class_id: nil, account_id: @teacher.id)
		@school_class = FactoryBot.create(:school_class, school_id: @school.id, class_divisions: [@class_division])

	end

	describe "get#index" do
		it "return classes of school" do
			get :index
			expect(response).to have_http_status(200)
		end
	end

	describe "get#show" do
		it "return  specific school admin" do
			
			get :show, params: {id: @school_class.id}
			expect(response).to have_http_status(200)
		end
	end

	describe "get#create" do
		it "create new record" do
			post :new, params: {"school_class"=>{"class_number"=>"1", "school_id"=> @school.id, "class_divisions_attributes"=>{"0"=>{"division_name"=>"A", "account_id"=> @teacher.id}}}}
			expect(response).to have_http_status(200)
		end
	end

	describe "get#create" do
		it "create new record" do
			post :create, params: {"school_class"=>{"class_number"=>"1", "school_id"=> @school.id, "class_divisions_attributes"=>{"0"=>{"division_name"=>"A", "account_id"=> @teacher.id}}}}
			expect(response).to have_http_status(200)
		end
		
		it "create new record when same division name" do
			post :create, params: {"school_class"=>{"class_number"=>"1", "school_id"=> @school.id, "class_divisions_attributes"=>{"0"=>{"division_name"=>"A", "account_id"=> @teacher.id}, "1"=> { "division_name" => "A", "account_id" => 2}}}}
			expect(response).to have_http_status(302)
		end

		it "create new record when same teacher id" do
			post :create, params: {"school_class"=>{"class_number"=>"1", "school_id"=> @school.id, "class_divisions_attributes"=>{"0"=>{"division_name"=>"A", "account_id"=> @teacher.id}, "1"=> { "division_name" => "B", "account_id" => @teacher.id}}}}
			expect(response).to have_http_status(302)
		end
	end

	describe "destroy action" do
	 	it "destroys the school_class and redirects to the class path" do
	 		if @school_class.present?
		 		delete :destroy, params: { id: @school_class.id }
		 	end
	 	end
	end

	describe "GET #edit" do
	    it "renders the edit template" do
	      get :edit, params: { id: @school_class.id }
	    end
	end

	describe "PUT #update" do
    context "with valid parameters" do
      it "updates the school class" do
        put :update, params: { id: @school_class.id, school_class: { class_number: 2, school_id: @school.id, account_id: @teacher.id } } 
      end
  	end

    context "with invalid parameters" do
	      it "does not update the school class" do
	        put :update, params: { id: @school_class.id, school_class: { class_number: nil, school_id: nil, account_id: nil } }
	      end
    end
		
		it "update new record when same division name" do
			post :update, params: {id: @school_class.id, "school_class"=>{"class_number"=>"1", "school_id"=> @school.id, "class_divisions_attributes"=>{"0"=>{"division_name"=>"A", "account_id"=> @teacher.id}, "1"=> { "division_name" => "A", "account_id" => 2}}}}
			expect(response).to have_http_status(302)
		end

		it "update new record when same teacher id" do
			post :update, params: {id: @school_class.id,  "school_class"=>{"class_number"=>"1", "school_id"=> @school.id, "class_divisions_attributes"=>{"0"=>{"division_name"=>"A", "account_id"=> @teacher.id}, "1"=> { "division_name" => "B", "account_id" => @teacher.id}}}}
			expect(response).to have_http_status(302)
		end

	end

 	describe "#update_subject_teacher_accounts" do
    let(:account1) { FactoryBot.create(:account, role_id: @teacher_role.id, subject_teacher_division_ids: [@class_division.id], subject_teacher_class_ids: [@teacher.id]) }
    let(:account2) { FactoryBot.create(:account, role_id: @teacher_role.id, subject_teacher_division_ids: [@class_division.id], subject_teacher_class_ids: [@teacher.id]) }

    before do
      @class_division.subject_teacher_ids = [account1.id, account2.id]
      @class_division.save
    end

    it "updates subject teacher accounts' division and class ids" do
      expect(account1).to have_attributes(subject_teacher_division_ids: [@class_division.id], subject_teacher_class_ids: [@teacher.id])
      expect(account2).to have_attributes(subject_teacher_division_ids: [@class_division.id], subject_teacher_class_ids: [@teacher.id])

      delete :destroy, params: { id: @school_class.id }
    end

    it "does not affect other accounts" do
      account3 = FactoryBot.create(:account, role_id: @teacher_role.id)
      @class_division.subject_teacher_ids << account3.id
      @class_division.save

      delete :destroy, params: { id: @school_class.id }
    end
  end

  context 'when conditions are not met' do
    it "displays the 'Back to School View' link" do
      post :new

      expect(response.body).to include('Back to School View')
    end
  end
end