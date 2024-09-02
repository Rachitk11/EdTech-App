module AccountBlock
  class SmsAccount < Account
    include Wisper::Publisher
    validates :full_phone_number, uniqueness: true, presence: true
  end
end
