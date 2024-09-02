FactoryBot.define do
	factory :profile, class: "BxBlockProfile::Profile" do
		user_name {FFaker::Name.first_name}
		# last_name {FFaker::Name.first_name}
		full_phone_number {FFaker::PhoneNumber.phone_number}
		email {FFaker::Internet.email}
		# photo { 'public/uploads/bx_block_profile/profile/photo/1/index.jpeg' }
		photo { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/index.jpeg'), 'photo/jpeg') }
		guardian_email {FFaker::Internet.email}
		guardian_name {FFaker::Name.first_name}
		guardian_contact_no {FFaker::PhoneNumber.phone_number}
		# password {"1234"}
		teacher_unique_id {rand(100..999)}
		employee_unique_id {rand(100..999)}	
		student_unique_id {rand(100..999)}
		account_id { 154 }

	end
end