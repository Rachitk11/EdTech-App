module BxBlockElasticsearch
  class AssignmentSerializer < BuilderBase::BaseSerializer
    attributes :title, :description, :school_id

    # attributes :assignment_pdf do |object|
    #   if object.assignment.attached?
    #     Rails.application.routes.url_helpers.rails_blob_url(object.assignment, only_path: true)
    #   else
    #     nil
    #   end
    # end
  end
end
