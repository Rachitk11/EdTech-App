FactoryBot.define do
  factory :terms_and_conditions, class: 'BxBlockTermsAndConditions::TermsAndCondition' do
    name {"First Term"}
    description {"This is description"}
  end
end