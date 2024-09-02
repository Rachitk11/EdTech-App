require 'rails_helper'

RSpec.describe BxBlockRolesPermissions::Role, type: :model do
   before(:each) do
		@role = FactoryBot.create(:role, name:"role")
	end

	it "is not valid without name" do
		@role.name = nil
  	    expect(@role).to_not be_valid
	end
end
