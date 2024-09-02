module BxBlockProfile
  module UpdateAccountCommand
    extend self

    def execute(account_id, params)
      validator = UpdateAccountValidator.new(account_id, params)

      unless validator.valid?
        return [:unprocessable_entity, validator.errors.full_messages]
      end

      account = validator.account
      attrs   = validator.attributes
      return [:ok, account.reload] if account.update(attrs)


      [:unprocessable_entity, [account.errors.full_messages.first]]
    end
  end
end
