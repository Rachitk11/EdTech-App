require 'rails_helper'

RSpec.describe 'BxBlockContentManagement::AboutUs', type: :model do
  before(:each) do
    @about_us = BxBlockContentManagement::AboutUs.create(email: "support@example.com", phone_number: 8172635478, title: "Title", description: "This is description")
  end

	context 'create a about us' do
    BxBlockContentManagement::AboutUs.delete_all
		about_us = BxBlockContentManagement::AboutUs.create(email: "support1@example.com", phone_number: 8172635477, title: "Title1", description: "This is description1")

    it "is not valid without email" do
      about_us = build(:about_us, email: nil)
      expect(about_us).not_to be_valid
    end

    it "is not valid without phone_number" do
      about_us = build(:about_us, phone_number: nil)
      expect(about_us).not_to be_valid
    end
	end

  context "only_one_entry_allowed method" do
    it "should allow creating a new entry when none exists" do
      about_us = BxBlockContentManagement::AboutUs.create(email: "support2@example.com", phone_number: 8172635488, title: "Title2", description: "This is description2")
      expect(about_us.valid?).to be false
    end

    it "should not allow creating a new entry when one already exists" do
      existing_about_us = BxBlockContentManagement::AboutUs.create(email: "support29@example.com", phone_number: 8172635488, title: "Title29", description: "This is description29")
      new_about_us = BxBlockContentManagement::AboutUs.create(email: "support8@example.com", phone_number: 8172635488, title: "Title21", description: "This is description21")
      expect(new_about_us.valid?).to be false
      expect(new_about_us.errors.full_messages).to include('Only one entry is allowed, please delete the existing one to create a new entry.')
    end

    it "should allow updating an existing entry" do
      existing_about_us = BxBlockContentManagement::AboutUs.create
      existing_about_us.description = "New value"
      expect(existing_about_us.valid?).to be false
    end
  end
end