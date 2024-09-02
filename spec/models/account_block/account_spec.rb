require 'rails_helper'

RSpec.describe AccountBlock::Account, type: :model do

  before(:each) do
		@role_publisher = BxBlockRolesPermissions::Role.find_or_create_by(name: "Publisher")
		@role_student = BxBlockRolesPermissions::Role.find_or_create_by(name: "Student")
		@role_teacher = BxBlockRolesPermissions::Role.find_or_create_by(name: "Teacher")
		@role_school_admin = BxBlockRolesPermissions::Role.find_or_create_by(name: "School Admin")
		
		@publisher = FactoryBot.create(:account, role_id: @role_publisher.id, full_phone_number: "8787656545", bank_account_number:"987876765654")
		@student = FactoryBot.create(:account, role_id: @role_student.id, student_unique_id: "ST558", full_phone_number:"8787654343", guardian_email: "guardian@gmail.com")
		@teacher = FactoryBot.create(:account, role_id: @role_teacher.id, full_phone_number:"9876654543")
		@school_admin = FactoryBot.create(:account, role_id: @role_school_admin.id, full_phone_number: "9845678765")
	end

  it "is not valid without email" do
  	@teacher.email = nil
  	expect(@teacher).to_not be_valid
  end

  it "is not valid without guardian email" do
  	@student.guardian_email = nil
  	expect(@student).to_not be_valid
  end

  it "is not valid without student unique code" do
  	@student.student_unique_id = nil
  	expect(@student).to_not be_valid
  end

  it "is not valid without  valid email" do
  	@teacher.email = "wrong"
  	expect(@teacher).to_not be_valid
  end

  it "is not valid without teacher_unique_id" do
  	@teacher.teacher_unique_id = nil
  	expect(@teacher).to_not be_valid
  end
end
