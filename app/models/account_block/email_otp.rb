module AccountBlock
  class EmailOtp < ApplicationRecord
    include Wisper::Publisher

    self.table_name = :email_otps

    validate :valid_email
    validates :email, presence: true

    before_create :generate_pin_and_valid_date

    attr_reader :phone

    def generate_pin_and_valid_date
      self.pin = rand(1_000..9_999)
      self.valid_until = Time.current + 5.minutes
    end

    private

    def valid_email
      unless URI::MailTo::EMAIL_REGEXP.match?(email)
        errors.add(:full_phone_number, "Invalid email format")
      end
    end
  end
end
