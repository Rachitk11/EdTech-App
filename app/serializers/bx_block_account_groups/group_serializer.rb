module BxBlockAccountGroups
  class GroupSerializer < BuilderBase::BaseSerializer
    attributes :name, :settings, :accounts
  end
end
