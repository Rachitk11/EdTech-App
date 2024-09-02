module AccountBlock
  class SocialAccountSerializer
    include FastJsonapi::ObjectSerializer

    attributes(:first_name, :last_name, :full_phone_number, :country_code, :phone_number, :email, :activated)
  end
end
