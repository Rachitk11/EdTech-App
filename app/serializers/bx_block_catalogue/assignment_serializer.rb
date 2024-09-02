module BxBlockCatalogue
  class AssignmentSerializer < BuilderBase::BaseSerializer
    attributes :id, :title, :description

    attributes :assignment_pdf do |object|
    	if object.assignment.attached?
      	Rails.application.routes.url_helpers.rails_blob_url(object.assignment, only_path: true)
	    else
	      nil
	    end
		end

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