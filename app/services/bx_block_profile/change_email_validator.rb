module BxBlockProfile
  class ChangeEmailValidator
    include ActiveModel::Validations

    attr_accessor(*[
      :account,
      :new_email,
    ])

    validates :account, :presence => {:message => 'not found'}
    validate :validate_account_type
    validate :validate_email

    def initialize(account_id, email)
      @account_id = account_id
      @email = email
    end

    def account
      return @account if defined?(@account)
      @account = AccountBlock::Account.find_by(:id => @account_id)
    end

    private

    def validate_email
      return if AccountBlock::EmailValidation.new(@email).valid?
      errors.add :new_email, 'is not valid'
    end

    def validate_account_type
      return unless account
      return unless (invalid_account_types).include?(account.type)
      errors.add :authentication, 'field cannot be edited'
    end

    def invalid_account_types
      ['AccountBlock::EmailAccount', 'EmailAccount']
    end
  end
end
