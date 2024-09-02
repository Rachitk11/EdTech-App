module BxBlockMultipageforms2
  class UserProfileSerializer < BuilderBase::BaseSerializer
    attributes *[
        :id,
        :first_name,
        :last_name,
        :phone_number,
        :email,
        :gender,
        :country,
        :industry,
        :message
        ]

  	
  end
end