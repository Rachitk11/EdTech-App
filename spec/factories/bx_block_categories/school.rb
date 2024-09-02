FactoryBot.define do
	factory :school, class: "BxBlockCategories::School" do
		name {FFaker::Name.first_name}
		principal_name {FFaker::Name.first_name}
		phone_number {FFaker::PhoneNumber.phone_number}
		email {FFaker::Internet.email}
		board {"HBSE"}
	end
end