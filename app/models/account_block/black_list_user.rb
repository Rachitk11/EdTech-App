module AccountBlock
  class BlackListUser < AccountBlock::ApplicationRecord
    self.table_name = :black_list_users
    belongs_to :account, class_name: "AccountBlock::Account"

    def user_mobile_number
      account.full_phone_number
    end

    def user_email
      account.email
    end

    def user_type
      account.user_type
    end
  end
end
