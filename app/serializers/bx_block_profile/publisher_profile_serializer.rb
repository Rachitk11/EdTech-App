module BxBlockProfile
  class PublisherProfileSerializer < BuilderBase::BaseSerializer
    attributes *[
      :id,
      :email,
      :country,
      :address,
      :account_id,
      :user_name,
      :school_id,
      :employee_unique_id,
      :full_phone_number, 
      # :photo
    ]
  end
end