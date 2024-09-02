module BxBlockProfile
  class ChangePasswordValidator
    include ActiveModel::Validations

    attr_accessor(*[
      :account,
      :new_password,
    ])

    validates :account, :presence => {:message => 'not found'}
    validate :authenticated
    validates :new_password, :format => {
      :with => AccountBlock::PasswordValidation.regex,
      :multiline => true,
    }

    def initialize(account_id, password, new_password)
      @account_id = account_id
      @password = password
      @new_password = new_password
    end

    def account
      return @account if defined?(@account)
      @account = AccountBlock::Account.find_by(:id => @account_id)
    end

    private

    def authenticated
      return unless account
      return if account.authenticate(@password)
      errors.add :base, 'Invalid credentials'
    end
  end
end
