module BxBlockCategories
  class StudentDetailsSerializer < BuilderBase::BaseSerializer
    attribute :name do |acc|
    	acc&.first_name
    end

    attribute :student_id do |acc|
    	acc&.student_unique_id
    end

    attribute :class do |acc|
    	acc&.class_division&.school_class&.class_number
    end

    attribute :division do |acc|
    	acc&.class_division&.division_name
    end

    # attribute :department do |acc|
    # 	acc.class_division.department rescue nil
    # end
  end
end
