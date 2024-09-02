module BxBlockProfile
  class ChangePhoneValidator
    include ActiveModel::Validations

    attr_accessor(*[
      :account,
      :new_phone,
    ])

    validates :account, :presence => {:message => 'not found'}
    validate :validate_account_type
    validate :validate_phone

    def initialize(account_id, phone)
      @account_id = account_id
      @phone = phone
    end

    def account
      return @account if defined?(@account)
      @account = AccountBlock::Account.find_by(:id => @account_id)
    end

    private

    def validate_phone
      return if AccountBlock::PhoneValidation.new(@phone).valid?
      errors.add :new_phone_number, 'is not valid'
    end

    def validate_account_type
      return unless account
      return unless invalid_account_types.include?(account.type)
      errors.add :authentication, 'field cannot be edited'
    end

    def invalid_account_types
      ['AccountBlock::SmsAccount', 'SmsAccount']
    end
  end
end
