module BxBlockProfile
  class DegreeSerializer < BuilderBase::BaseSerializer
    attributes *[
     :id,
     :degree_name
    ]
  end
end