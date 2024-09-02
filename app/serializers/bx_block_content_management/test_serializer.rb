module BxBlockContentManagement
  class TestSerializer < BuilderBase::BaseSerializer
    attributes :id, :description, :created_at, :updated_at
  end
end
