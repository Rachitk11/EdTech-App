FactoryBot.define do
	factory :class_division, class: "BxBlockCategories::ClassDivision" do
		division_name {FFaker::Name.unique.name}
	end
end