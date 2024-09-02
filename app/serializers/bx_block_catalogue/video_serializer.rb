module BxBlockCatalogue
  class VideoSerializer < BuilderBase::BaseSerializer
  	include FastJsonapi::ObjectSerializer
    attributes :id, :title, :description , :video , :time_hour, :time_min

    attributes :teacher_name do |object| 
    	AccountBlock::Account.find_by(id: object.account_id).first_name rescue nil
  	end

  	attributes :subject do |object| 
    	BxBlockCatalogue::Subject.find_by(id: object.subject_id).subject_name rescue nil
  	end

    attributes :class do |object|
      BxBlockCategories::SchoolClass.find(object.school_class_id).class_number rescue nil
    end

    attributes :division do |object|
      BxBlockCategories::ClassDivision.find(object.class_division_id).division_name rescue nil
    end
	end
end