module AccountBlock
  class SmsOtp < ApplicationRecord
    self.table_name = :sms_otps

    include Wisper::Publisher

    before_validation :parse_full_phone_number

    before_create :generate_pin_and_valid_date
    after_create :send_pin_via_sms

    validate :valid_phone_number
    validates :full_phone_number, presence: true

    attr_reader :phone

    def generate_pin_and_valid_date
      self.pin = rand(1_000..9_999)
      self.valid_until = Time.current + 5.minutes
    end

    def send_pin_via_sms
      message = "Your Pin Number is #{pin}"
      txt = BxBlockSms::SendSms.new("+#{full_phone_number}", message)
      txt.call
    end

    private

    def parse_full_phone_number
      @phone = Phonelib.parse(full_phone_number)
      self.full_phone_number = @phone.sanitized
    end

    def valid_phone_number
      unless Phonelib.valid?(full_phone_number)
        errors.add(:full_phone_number, "Invalid or Unrecognized Phone Number")
      end
    end
  end
end
