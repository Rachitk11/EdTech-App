module BxBlockProfile
class CustomUserProfileFields < ApplicationRecord
	 self.table_name = :bx_block_profile_custom_user_profile_fields

	 validates :name, presence: true, uniqueness: true
	 validates :field_type, presence: true, inclusion: { in: ['text', 'password', 'email', 'number', 'range', 'date','time','datetime','checkbox', 'radio','select','textarea','file','search'], message: "%{value} is not a valid field type" }
end
end