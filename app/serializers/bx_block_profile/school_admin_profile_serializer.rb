module BxBlockProfile
  class SchoolAdminProfileSerializer < BuilderBase::BaseSerializer
    attributes *[
      :id,
      :email,
      :country,
      :address,
      :account_id,
      :school_id,
      :user_name,
      :full_phone_number, 
      # :photo
    ]
  end
end