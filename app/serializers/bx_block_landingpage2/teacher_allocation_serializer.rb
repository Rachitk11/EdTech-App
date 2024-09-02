module BxBlockLandingpage2
  class TeacherAllocationSerializer < BuilderBase::BaseSerializer

    attributes :class do |object| 
      object&.class_division&.school_class&.class_number
    end

    attributes :division do |object| 
      BxBlockCategories::ClassDivision.find_by(id: object.class_division_id).division_name rescue nil
    end

    attributes :subject do |object| 
      object&.subject&.subject_name
    end
  end
end
