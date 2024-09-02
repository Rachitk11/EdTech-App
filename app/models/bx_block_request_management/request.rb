module BxBlockRequestManagement
  class Request < BxBlockRequestManagement::ApplicationRecord
    self.table_name = :requests

    before_create do
      self.status = "pending"
    end

    belongs_to :sender, foreign_key: :sender_id, class_name: "AccountBlock::Account"
    belongs_to :account_group, foreign_key: :account_group_id,
      class_name: "BxBlockAccountGroups::Group"

    enum status: %i[pending accepted rejected], _prefix: :status
    validates :rejection_reason, presence: true, on: :change_status_rejected

    scope :pending, -> { where(status: "pending") }
    scope :accepted, -> { where(status: "accepted") }
    scope :rejected, -> { where(status: "rejected") }
  end
end
