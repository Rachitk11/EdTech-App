FactoryBot.define do
	factory :account, class: "AccountBlock::Account" do
		first_name {FFaker::Name.first_name}
		last_name {FFaker::Name.first_name}
		# full_phone_number {FFaker::PhoneNumber.phone_number}
		full_phone_number { "1234567890" }
		email {FFaker::Internet.email}
		guardian_email {FFaker::Internet.email}
		guardian_name {FFaker::Name.first_name}
		guardian_contact_no {FFaker::PhoneNumber.phone_number}
		teacher_unique_id {rand(100..9999)}
		employee_unique_id {rand(100..9999)}	
		student_unique_id {"STUD#{rand(100..9999)}"}
		bank_account_number{rand(100..99999999999999)}
		ifsc_code{FFaker::Number.number}
	end
end