FactoryBot.define do
	factory :school_class, class: "BxBlockCategories::SchoolClass" do
		class_number {FFaker::Number.number}
	end
end