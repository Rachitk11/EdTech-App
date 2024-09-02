module BxBlockContentManagement
  class ExamSerializer < BuilderBase::BaseSerializer
    attributes :id, :heading, :description, :created_at, :updated_at
  end
end
