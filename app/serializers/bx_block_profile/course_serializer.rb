module BxBlockProfile
  class CourseSerializer < BuilderBase::BaseSerializer
    attributes *[
      :course_name,
      :duration,
      :year
    ]
  end
end
