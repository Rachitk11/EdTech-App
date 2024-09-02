module BxBlockForgotPassword
  class SmsOtpSerializer < BuilderBase::BaseSerializer
    attributes :full_phone_number, :activated, :created_at
    attributes :pin, :valid_until
  end
end
