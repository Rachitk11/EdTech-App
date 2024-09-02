module BxBlockContentManagement
  class Bookmark < ApplicationRecord
    self.table_name = :bookmarks
    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :content, class_name: "BxBlockContentManagement::Content"
    validates_presence_of :account_id, :content_id
    validates :account_id, uniqueness: { scope: :content_id, message: "content with this account is already taken"}
  end
end
