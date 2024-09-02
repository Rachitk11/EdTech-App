module BxBlockContentManagement
  class Follow < ApplicationRecord
    self.table_name = :follows
    belongs_to :account, class_name: "AccountBlock::Account"
    validates :account_id, uniqueness: { scope: :content_provider_id,
                                         message: "content provider with this account is already taken"}
  end
end
