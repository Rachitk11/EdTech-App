module AccountBlock
  class EmailAccountSerializer
    include FastJsonapi::ObjectSerializer

    attributes(:first_name, :last_name, :full_phone_number, :country_code, :phone_number, :guardian_email,:guardian_name,:guardian_contact_no, :email, :activated)
  end
end
