module AccountBlock
  class PhoneValidation
    include ActiveModel::Validations

    attr_accessor :phone

    validate :validate_phone

    def initialize(phone)
      @phone = phone
    end

    private

    def validate_phone
      return if Phonelib.valid?(@phone)
      errors.add :phone_number, "is not valid"
    end
  end
end
