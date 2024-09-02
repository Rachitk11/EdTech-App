module BxBlockMultipageforms2
	class UserProfile < BuilderBase::ApplicationRecord
		self.table_name = :bx_block_multipageforms2_user_profiles
		validates :first_name, :last_name, :phone_number, :email, :gender, :country, :industry, :message, presence: true

    	enum industry: { education: 0, food: 1, marketing: 2 }
	end
end
