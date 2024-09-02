module AccountBlock
  class AccountSerializer < BuilderBase::BaseSerializer
    attributes(:full_phone_number, :guardian_email,:guardian_name, :email, :activated, :is_reset, :publication_house_name, :school_id, :teacher_unique_id, :student_unique_id)
    attribute :role do |acc|
      acc.role&.name
    end

    attribute :school_name do |acc|
      acc.school&.name
    end

    attribute :name do |acc|
      acc.first_name
    end

    attribute :student_details do |acc|
		BxBlockCategories::StudentDetailsSerializer.new(acc)
    end

    attribute :teacher_details do |acc|
    	_class_division = acc.class_division
    	teacher = AccountBlock::Account.find_by_id(_class_division&.account_id)
		BxBlockCategories::TeacherDetailsSerializer.new(teacher)
    end

    attribute :class_allocated do |acc|
    	class_division = BxBlockCategories::ClassDivision.where(account_id: acc.id)
    	BxBlockCategories::ClassAllocatedSerializer.new(class_division)
    end
  end
end
