require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  before do
    @admin_user = AdminUser.create!(
      email: 'admin101@example.com',
      password: 'password',
      role: :super_admin
    )
  end

  describe "validations" do
    it "validates presence of role" do
      @admin_user.role = nil
      expect(@admin_user).not_to be_valid
      expect(@admin_user.errors[:role]).to include("can't be blank")
    end

    it "requires school_id to be present for sub admin" do
      @admin_user.role = :sub_admin
      @admin_user.school_id = nil
      expect(@admin_user).not_to be_valid
      expect(@admin_user.errors[:school_id]).to include("must be present for sub admin")
    end

    it "rejects school_id if present for super admin" do
      @admin_user.role = :super_admin
      @admin_user.school_id = 1
      expect(@admin_user).not_to be_valid
      expect(@admin_user.errors[:school_id]).to include("No need for super admin to have a school ID")
    end
  end
end
