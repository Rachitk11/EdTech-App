module BxBlockAccountGroups
  class AccountGroup < ApplicationRecord
    self.table_name = "account_groups_account_groups"

    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :group, class_name: "BxBlockAccountGroups::Group",
      foreign_key: "account_groups_group_id"
  end
end
