FactoryBot.define do
  factory :about_us, class: 'BxBlockContentManagement::AboutUs' do
	phone_number {8193256548}
	email {FFaker::Internet.email}
    title {"Title"}
    description {"This is description"}
  end
end