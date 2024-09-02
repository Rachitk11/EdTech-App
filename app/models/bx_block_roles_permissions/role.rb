module BxBlockRolesPermissions
  class Role < ApplicationRecord
    self.table_name = :roles

    has_many :accounts, class_name: "AccountBlock::Account", dependent: :destroy
    
    validates_presence_of :name
    # validates_uniqueness_of :name

  end
end
