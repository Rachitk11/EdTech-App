module BxBlockLandingpage2
  class VideoSerializer < BuilderBase::BaseSerializer
  	include FastJsonapi::ObjectSerializer
    attributes :id, :title

  	attributes :subject do |object| 
    	BxBlockCatalogue::Subject.find_by(id: object.subject_id).subject_name rescue nil
  	end

    attributes :date_assigned do |object| 
      rescue nil
    end

    attributes :status do |object| 
      rescue nil
    end
	end
end