module BxBlockProfile
  class EducationalQualificationSerializer < BuilderBase::BaseSerializer
    attributes *[
     :id,
     :school_name,
     :start_date,
     :end_date,
     :grades,
     :description,
     :make_grades_public,
     :profile_id
    ]
    attributes :educational_qualification_field_studys do |object|
      object.educational_qualification_field_studys.map do |edu_qual|
        {
          id: edu_qual.field_study.id,
          field_of_study: edu_qual.field_study.field_of_study
        }
      end
    end

    attributes :degree_educational_qualifications do |object|
     object.degree_educational_qualifications.map do |deg_qual|
        {
          id:deg_qual.degree.id,
          degree_name: deg_qual.degree.degree_name
        }
      end
    end
  end
end