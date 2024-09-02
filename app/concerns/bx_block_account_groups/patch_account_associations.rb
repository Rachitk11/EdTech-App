module BxBlockAccountGroups
  module PatchAccountAssociations
    extend ActiveSupport::Concern

    included do
      belongs_to :role, class_name: "BxBlockRolesPermissions::Role", required: false
      has_many :account_groups, class_name: "BxBlockAccountGroups::AccountGroup"
      has_many :groups, through: :account_groups,
        foreign_key: "account_groups_group_id"

      def is_groups_admin?
        role.present? && role.name == BxBlockAccountGroups::Group::ROLE_ADMIN
      end
    end
  end
end
