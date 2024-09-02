module BxBlockLandingpage2
  class TeacherAllocatedSerializer < BuilderBase::BaseSerializer
   
    attribute :teacher_id do |object|
      object&.account.id
    end

    attribute :teacher_unique_id do |object|
      object&.account.teacher_unique_id
    end

    attribute :name do |object|
      object&.account.first_name
    end

    attributes :class do |object| 
      # object&.class_division&.school_class&.class_number
    end

    attributes :division do |object| 
      # BxBlockCategories::ClassDivision.find_by(id: object.class_division_id).division_name rescue nil
    end

    attributes :subject do |object| 
      object&.subject&.subject_name
    end
  end
end
