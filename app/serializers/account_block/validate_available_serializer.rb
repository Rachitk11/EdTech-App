module AccountBlock
  class ValidateAvailableSerializer
    include FastJsonapi::ObjectSerializer

    attributes :activated

    set_id do |object|
      object.class.name.underscore
    end

    attribute :email do |object|
      object.is_a?(EmailAccount) ? object.email : nil
    end

    attribute :phone_number do |object|
      object.is_a?(SmsAccount) ? object.full_phone_number : nil
    end

    attribute :account_exists do |object|
      object.id.present? ? true : false
    end
  end
end
