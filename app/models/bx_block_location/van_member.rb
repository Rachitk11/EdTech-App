module BxBlockLocation
  class VanMember < AccountBlock::ApplicationRecord
    self.table_name = :van_members

    belongs_to :van, class_name: 'BxBlockLocation::Van'
    belongs_to :account, class_name: 'AccountBlock::Account'
  end
end
