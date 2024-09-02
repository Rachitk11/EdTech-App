require 'rails_helper'

RSpec.describe BxBlockCategories::School, type: :model do
   before(:each) do
		@school = FactoryBot.create(:school, name: "HIC School UP", phone_number: "8767656565")
	end

	it "is not valid without email" do
		@school.email = nil
  	    expect(@school).to_not be_valid
	end
end
