FactoryBot.define do
	factory :order, class: "BxBlockOrderManagement::Order" do
		# quantity { 1 }
		order_number {FFaker::Number.number}
		amount {rand(5.0..50.0).round(2)}
		account_id {124}
		status {"confirmed"}
	end
end