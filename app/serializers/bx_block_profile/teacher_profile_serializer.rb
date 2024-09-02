module BxBlockProfile
  class TeacherProfileSerializer < BuilderBase::BaseSerializer
    attribute :name do |object|
        object&.first_name
    end

    attribute :contact_number do |object|
        object.full_phone_number
    end

    attribute :email do |object|
        object.email
    end

    attribute :department do |object|
        object.department rescue nil
    end
  end
end