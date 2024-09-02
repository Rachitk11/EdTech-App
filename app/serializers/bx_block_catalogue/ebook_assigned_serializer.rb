module BxBlockCatalogue
  class EbookAssignedSerializer < BuilderBase::BaseSerializer

		attributes :ebook_name do |object| 
    	object.ebook.title rescue nil
  	end

  	attributes :subject do |object| 
      object.ebook.subject rescue nil
  	end

  	attributes :class do |object|
  		BxBlockCategories::SchoolClass.find_by(id: object.school_class_id).class_number rescue nil
  	end

  	attributes :division do |object|
  		BxBlockCategories::ClassDivision.find_by(id: object.class_division_id).division_name rescue nil
  	end
	end
end