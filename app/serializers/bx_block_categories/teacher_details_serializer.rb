module BxBlockCategories
  class TeacherDetailsSerializer < BuilderBase::BaseSerializer
    attribute :name do |acc|
    	acc&.first_name
    end

    attribute :contact_number do |acc|
    	acc&.full_phone_number
    end

    attribute :department do |acc|
    	acc.department rescue nil
    end
  end
end
