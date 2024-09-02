module BxBlockProfile
  class ProjectSerializer < BuilderBase::BaseSerializer
    attributes *[
     :id,
     :project_name,
     :start_date,
     :end_date,
     :add_members,
     :url,
     :description,
     :make_projects_public,
     :profile_id
    ]

    attributes :associated_projects do |object|
      object.associated_projects.map do |ass_pro|
        {
          id: ass_pro.associated.id,
          associated_with_name: ass_pro.associated.associated_with_name
        }
      end
    end

  end
end