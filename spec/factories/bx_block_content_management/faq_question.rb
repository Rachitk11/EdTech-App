FactoryBot.define do
  factory :faq_question, class: 'BxBlockContentManagement::FaqQuestion' do
    question {"First Question"}
    answer {"This is answer"}
  end
end