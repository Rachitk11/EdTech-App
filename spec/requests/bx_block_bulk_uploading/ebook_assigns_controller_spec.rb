require 'rails_helper'

RSpec.describe BxBlockBulkUploading::EbookAssignsController, type: :controller do
  before(:each) do
	  @teacher_role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Teacher')
	  @school = FactoryBot.create(:school, name: 'BGPS', phone_number: 7890654321)
	  @teacher = FactoryBot.create(:account, role_id: @teacher_role.id, school_id: @school.id)
	  @class_division = FactoryBot.create(:class_division, school_class_id: nil, account_id: @teacher.id)
		@school_class = FactoryBot.create(:school_class, school_id: @school.id, class_divisions: [@class_division])
    @token = BuilderJsonWebToken::JsonWebToken.encode(@teacher.id)
  end

  describe 'POST ebook_assign' do
    it 'assigns book successfully to students' do
      ebook = FactoryBot.create(:ebook)
      @role = BxBlockRolesPermissions::Role.find_or_create_by(name: 'Student')
      @acc = FactoryBot.create(:account, role_id: @role.id, class_division_id: @class_division.id, activated: true)

      post :ebook_assign, params: { ebook_id: ebook.id, student_ids: [@acc.id], alloted_date: Date.today, school_class_id:@school_class.id , class_division_id: @class_division.id ,school_id:@school.id, token: @token }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Book assigned successful')
    end
  end
end