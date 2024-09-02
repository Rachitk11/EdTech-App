require 'rails_helper'

RSpec.describe 'BxBlockContentManagement::FaqQuestion', type: :model do
	context 'create a faq question' do
		let(:faq_question) { create(:faq_question) }

    it "is valid with valid attributes" do
      expect(faq_question).to be_valid
    end

    it "is not valid without answer" do
      faq_question = build(:faq_question, answer: nil)
      expect(faq_question).not_to be_valid
    end
	end
end