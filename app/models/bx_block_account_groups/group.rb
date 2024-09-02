module BxBlockAccountGroups
  class Group < BxBlockAccountGroups::ApplicationRecord
    self.table_name = :account_groups_groups
    before_save :process_settings
    validates :name, presence: true
    has_many :account_groups, foreign_key: "account_groups_group_id", dependent: :destroy
    has_many :accounts, through: :account_groups

    ROLE_ADMIN = "group_admin"
    ROLE_BASIC = "group_basic"

    def process_settings
      self.settings = JSON.parse(settings) if settings.is_a? String
    end
  end
end
