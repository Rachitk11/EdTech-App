module BxBlockCategories
  class ClassAllocatedSerializer < BuilderBase::BaseSerializer
    attribute :class do |class_division|
    	class_division&.school_class.class_number
    end

    attribute :class_division do |class_division|
    	class_division&.division_name
    end

    attribute :department do |class_division|
        AccountBlock::Account.find(class_division.account_id).department rescue nil
    end
  end
end
