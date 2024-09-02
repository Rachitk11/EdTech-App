require 'rails_helper'

RSpec.describe 'BxBlockTermsAndConditions::TermsAndCondition', type: :model do
  before(:each) do
    @term = BxBlockTermsAndConditions::TermsAndCondition.create(name: "name11", description: "This is description11")
  end

  context "Association test" do
    it "should belongs to " do
      t = BxBlockTermsAndConditions::TermsAndCondition.reflect_on_association(:user_terms_and_conditions)
      expect(t.macro).to eq(:has_many)
    end
  end
  context 'create a term and condition' do
    BxBlockTermsAndConditions::TermsAndCondition.delete_all
    terms_and_conditions = BxBlockTermsAndConditions::TermsAndCondition.create(name: "name2", description: "This is description2")

    it "is valid with valid attributes" do
      expect(terms_and_conditions).to be_valid
    end
     it "is not valid without description" do
      terms_and_conditions = build(:terms_and_conditions, description: nil)
      expect(terms_and_conditions).not_to be_valid
    end
  end

  context "only_one_entry_allowed method" do
    it "should allow creating a new entry when none exists" do
      BxBlockTermsAndConditions::TermsAndCondition.delete_all
      term = BxBlockTermsAndConditions::TermsAndCondition.create(name: "name2", description: "This is description2")
      expect(term.valid?).to be true
    end

    it "should not allow creating a new entry when one already exists" do
      existing_term = BxBlockTermsAndConditions::TermsAndCondition.create(name: "name29", description: "This is description29")
      new_term = BxBlockTermsAndConditions::TermsAndCondition.create(name: "name21", description: "This is description21")
      expect(new_term.valid?).to be false
      expect(new_term.errors.full_messages).to include('Only one entry is allowed, please delete the existing one to create a new entry.')
    end

    it "should allow updating an existing entry" do
      existing_term = BxBlockTermsAndConditions::TermsAndCondition.create
      existing_term.description = "New value"
      expect(existing_term.valid?).to be false
    end
  end
end