FactoryBot.define do
	factory :role, class: "BxBlockRolesPermissions::Role" do
		name {FFaker::Name.first_name}
	end
end